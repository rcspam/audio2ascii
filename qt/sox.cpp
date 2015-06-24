#include "sox.h"
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QDebug>
#include <QProcess>

Sox::Sox(QObject *parent) :
    QObject(parent)
{
}

QString Sox::bin(bool info)
{
    QString path;
    QFile soxApp;
    QString exe;
    if (info)
        exe = "soxi";
    else
        exe = "sox";

    if (soxApp.exists(qApp->applicationDirPath()+QDir::separator()+exe+".exe"))
        path = qApp->applicationDirPath()+QDir::separator()+exe+".exe";
    else if (soxApp.exists(qApp->applicationDirPath()+QDir::separator()+exe))
        path = qApp->applicationDirPath()+QDir::separator()+exe;
    else if (soxApp.exists(QDir::toNativeSeparators("/usr/bin/"+exe)))
        path = QDir::toNativeSeparators("/usr/bin/"+exe);
    else if (soxApp.exists(QDir::toNativeSeparators("/usr/local/bin/"+exe)))
        path = QDir::toNativeSeparators("/usr/local/bin/"+exe);

    return path;
}

QString Sox::about()
{
    QString desc;
    if (!bin(false).isEmpty()) {
        QProcess proc;
        proc.start(bin(false)+" --version");
        if (proc.waitForFinished()) {
            desc = proc.readAll().simplified();
            proc.close();
        }
    }
    return desc;
}

int Sox::samplerate(QString filename)
{
    int result = 0;
    QFile audiofile;
    if (audiofile.exists(filename) && !bin(true).isEmpty()) {
        QProcess proc;
        proc.start(bin(true)+" -r "+filename);
        proc.waitForFinished();
        result = proc.readAll().simplified().toInt();
        proc.close();
        if (result==0)
            emit error(tr("Unable to get samplerate"));
    }
    else
        emit error(tr("Audio file or Soxi does not exists"));

    return result;
}

QString Sox::dat(QString filename, int fps, int duration, int factor, int dimension)
{
    QString result;
    QString data = QDir::tempPath()+QDir::separator()+qApp->applicationName()+".dat";
    QString curves;
    QFile audioFile;
    QFile tmp(data);
    if (audioFile.exists(filename) && !bin(false).isEmpty()) {
        if (tmp.exists())
            tmp.remove();
        QProcess proc;
        QString exestring = bin(false)+" \""+filename+"\" -r "+QString::number(fps)+" \""+data+"\" trim 0 "+QString::number(duration);
        qDebug() << exestring;
        proc.start(exestring);
        proc.waitForFinished();
        proc.close();
    }
    else {
        emit error(tr("Audio file or Sox does not exists"));
        return result;
    }

    if (tmp.exists()) {
        if (tmp.open(QIODevice::ReadOnly|QIODevice::Text))
            curves = tmp.readAll();
        tmp.remove();
    }

    if (!curves.isEmpty()) {
        QString dat;
        QStringList lines = curves.split("\n", QString::SkipEmptyParts);
        dat.append("; "+qApp->applicationName()+" https://github.com/rcspam/audio2ascii\n; "+filename+"\n\n");
        foreach(QString line, lines) {
            if (!line.startsWith(";")) {
                QStringList cordinates = line.simplified().split(" ");
                int posMax=3;
                int posCurr=0;
                foreach(QString pos, cordinates) {
                    if (posCurr<posMax)
                    if (posCurr==1) {
                        dat.append(QString::number(pos.toDouble()*factor,'f',10));
                        if (dimension==1)
                            dat.append("\n");
                    }
                    if (posCurr==2 && dimension==2)
                        dat.append("_"+QString::number(pos.toDouble()*factor,'f',10)+"\n");
                    posCurr++;
                }
            }
        }
        result = dat;
    }
    if (result.isEmpty())
        emit error(tr("No data collected"));

    return result;
}

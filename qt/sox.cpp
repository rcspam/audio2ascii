#include "sox.h"
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QProcess>

Sox::Sox(QObject *parent) :
    QObject(parent)
{
}

QString Sox::bin()
{
    QString path;
    QFile soxApp;

    if (soxApp.exists(qApp->applicationDirPath()+QDir::separator()+"sox.exe"))
        path = qApp->applicationDirPath()+QDir::separator()+"sox.exe";
    else if (soxApp.exists(qApp->applicationDirPath()+QDir::separator()+"sox"))
        path = qApp->applicationDirPath()+QDir::separator()+"sox";
    else if (soxApp.exists(QDir::toNativeSeparators("/usr/bin/sox")))
        path = QDir::toNativeSeparators("/usr/bin/sox");
    else if (soxApp.exists(QDir::toNativeSeparators("/usr/local/bin/sox")))
        path = QDir::toNativeSeparators("/usr/local/bin/sox");

    return path;
}

QString Sox::about()
{
    QString desc;
    if (!bin().isEmpty()) {
        QProcess proc;
        proc.start(bin()+" --version");
        proc.waitForFinished();
        desc = proc.readAll().simplified();
        proc.close();
    }
    return desc;
}

QString Sox::dat(QString filename, int fps, int duration, int factor, bool x, bool y)
{
    emit status(tr("Generating data ..."));
    QString result;
    QString data = QDir::tempPath()+QDir::separator()+qApp->applicationName()+".dat";
    QString curves;
    QFile audioFile;
    QFile tmp(data);
    if (audioFile.exists(filename) && !bin().isEmpty()) {
        if (tmp.exists())
            tmp.remove();
        QProcess proc;
        QString exestring = bin()+" \""+filename+"\" -r "+QString::number(fps)+" \""+data+"\" trim 0 "+QString::number(duration);
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
        foreach(QString line, lines) {
            if (!line.startsWith(";")) {
                QStringList cordinates = line.simplified().split(" ");
                int posCurr=0;
                foreach(QString pos, cordinates) {
                    if (posCurr==1 && x) {
                        dat.append(QString::number(pos.toDouble()*factor,'f',10));
                        if (!y)
                            dat.append("\n");
                    }
                    if (posCurr==2 && y) {
                        if (x)
                            dat.append("_");
                        dat.append(QString::number(pos.toDouble()*factor,'f',10)+"\n");
                    }
                    posCurr++;
                }
            }
        }
        result = dat;
    }
    if (result.isEmpty())
        emit error(tr("No data collected"));
    else
        emit status(tr("Done"));

    return result;
}

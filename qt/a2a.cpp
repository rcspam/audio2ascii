#include "a2a.h"
#include "ui_a2a.h"
#include <QMessageBox>
#include <QFileDialog>
#include <QDir>
#include <QFile>
#include <QFileDialog>
#include <QTextStream>
#include <QSettings>
#include <QTimer>

a2a::a2a(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::a2a)
{
    ui->setupUi(this);
    resetParams();
    connect(&audio,SIGNAL(error(QString)),this,SLOT(errorHandler(QString)));
    connect(&audio,SIGNAL(status(QString)),this,SLOT(statusHandler(QString)));
    QTimer::singleShot(0,this,SLOT(loadConf()));
}

a2a::~a2a()
{
    saveConf();
    delete ui;
}

void a2a::loadConf()
{
    QSettings settings;
    settings.beginGroup("ui");
    if (settings.value("state").isValid())
        this->restoreState(settings.value("state").toByteArray());
    if (settings.value("size").isValid())
        this->resize(settings.value("size",QSize(320,256)).toSize());
    if (settings.value("pos").isValid())
        this->move(settings.value("pos",QPoint(0,0)).toPoint());
    if (settings.value("max").toBool() == true)
        this->showMaximized();
    settings.endGroup();
    settings.beginGroup("file");
    if (!settings.value("lastDir").isNull())
        lastDir = settings.value("lastDir").toString();
    settings.endGroup();
}

void a2a::saveConf()
{
    QSettings settings;
    settings.beginGroup("ui");
    settings.setValue( "state",this->saveState());
    settings.setValue("size",this->size());
    settings.setValue("pos",this->pos());
    if (this->isMaximized())
        settings.setValue("max","true");
    else
        settings.setValue("max","false");
    settings.endGroup();
    settings.beginGroup("file");
    if (!lastDir.isEmpty())
        settings.setValue("lastDir",lastDir);
    settings.endGroup();
}

void a2a::on_actionAboutApp_triggered()
{
    QMessageBox::about(this,"About "+qApp->applicationName(),"<h3>"+qApp->applicationName()+" "+qApp->applicationVersion()+"</h3><p>Audio curve generator for Natron/Nuke.</p><p>Made by <a href=\"https://github.com/rcspam\">rcspam</a> and <a href=\"https://github.com/olear\">olear</a>.</p>"+audio.about());
}

void a2a::on_actionAboutQt_triggered()
{
    QMessageBox::aboutQt(this);
}

void a2a::on_actionOpen_triggered()
{
    if (!ui->reload->isHidden())
        ui->reload->hide();
    QString openDir;
    if (!lastDir.isEmpty())
        openDir = lastDir;
    else
        openDir = QDir::homePath();
    QString fileName = QFileDialog::getOpenFileName(this,tr("Open audio file"), openDir, tr("Audio Files (*.wav)"));
    if (!fileName.isEmpty()) {
        active = fileName;
        QFileInfo file(fileName);
        lastDir = file.absolutePath();
        getData();
    }
}

void a2a::on_actionSave_triggered()
{
    if (!ui->reload->isHidden())
        ui->reload->hide();
    if (!ui->output->toPlainText().isEmpty()) {
        QString fileName = QFileDialog::getSaveFileName(this,tr("Save text file"), lastDir, tr("Text File (*.txt)"));
        if (!fileName.isEmpty()) {
            QFile output(fileName);
            if (output.open(QIODevice::WriteOnly|QIODevice::Text)) {
                QTextStream stream(&output);
                stream << ui->output->toPlainText();
                output.close();
            }
            if (output.exists()) {
                ui->statusBar->showMessage(tr("Text file saved"),5000);
                ui->actionSave->setEnabled(false);
            }
            else
                ui->statusBar->showMessage(tr("Failed to save text file"),5000);
        }
    }
    else
        ui->statusBar->showMessage(tr("Nothing to save"),5000);
}

void a2a::on_actionQuit_triggered()
{
    qApp->quit();
}

void a2a::resetParams()
{
    ui->spinBox_duration->clear();
    ui->spinBox_factor->clear();
    ui->spinBox_fps->clear();
    ui->output->clear();
    ui->curveX->setChecked(true);
    ui->curveY->setChecked(false);
    this->setWindowTitle(qApp->applicationName());
    ui->spinBox_factor->setValue(1000);
    ui->spinBox_fps->setValue(24);
    ui->spinBox_duration->setValue(60);
    ui->actionSave->setEnabled(false);
    active.clear();
    ui->output->setFocus();
    ui->reload->hide();
}

void a2a::getData()
{
    if (!ui->reload->isHidden())
        ui->reload->hide();
    ui->actionSave->setDisabled(true);
    ui->actionOpen->setDisabled(true);
    if (!active.isEmpty()) {
        qApp->processEvents();
        QString result = audio.dat(active,ui->spinBox_fps->value(),ui->spinBox_duration->value(),ui->spinBox_factor->value(),ui->curveX->isChecked(),ui->curveY->isChecked());
        if (!result.isEmpty()) {
            ui->output->setPlainText(result);
            ui->actionSave->setEnabled(true);
            ui->actionOpen->setEnabled(true);
            ui->output->setEnabled(true);
        }
    }
    else {
        ui->statusBar->showMessage(tr("No result"),5000);
        active.clear();
        ui->output->clear();
        ui->output->setEnabled(false);
        ui->actionSave->setEnabled(false);
        ui->actionSave->setEnabled(true);
    }
}

void a2a::errorHandler(QString error)
{
    if (!error.isEmpty())
        QMessageBox::warning(this,tr("Warning"),error);
}

void a2a::statusHandler(QString status)
{
    if (!status.isEmpty())
        ui->statusBar->showMessage(status,5000);
}

void a2a::on_reload_clicked()
{
    if (!ui->reload->isHidden() && !active.isEmpty()) {
        ui->reload->hide();
        getData();
    }
}

void a2a::on_spinBox_duration_valueChanged(int arg1)
{
    if (ui->reload->isHidden() && !active.isEmpty())
        ui->reload->show();
    ui->sliderDuration->setValue(arg1);
}

void a2a::on_spinBox_factor_valueChanged(int arg1)
{
    if (ui->reload->isHidden() && !active.isEmpty())
        ui->reload->show();
    ui->sliderFactor->setValue(arg1);
}

void a2a::on_spinBox_fps_valueChanged(int arg1)
{
    if (ui->reload->isHidden() && !active.isEmpty())
        ui->reload->show();
    ui->sliderFPS->setValue(arg1);
}

void a2a::on_sliderFPS_valueChanged(int value)
{
    ui->spinBox_fps->setValue(value);
}

void a2a::on_sliderFactor_valueChanged(int value)
{
    ui->spinBox_factor->setValue(value);
}

void a2a::on_sliderDuration_valueChanged(int value)
{
    ui->spinBox_duration->setValue(value);
}

void a2a::on_curveX_stateChanged(int arg1)
{
    Q_UNUSED(arg1)
    if (ui->reload->isHidden() && !active.isEmpty())
        ui->reload->show();
}

void a2a::on_curveY_stateChanged(int arg1)
{
    Q_UNUSED(arg1)
    if (ui->reload->isHidden() && !active.isEmpty())
        ui->reload->show();
}

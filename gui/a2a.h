#ifndef A2A_H
#define A2A_H

#include <QMainWindow>
#include "sox.h"

namespace Ui {
class a2a;
}

class a2a : public QMainWindow
{
    Q_OBJECT

public:
    explicit a2a(QWidget *parent = 0);
    ~a2a();

private slots:
    void on_actionAboutApp_triggered();
    void on_actionAboutQt_triggered();
    void on_actionOpen_triggered();
    void on_actionSave_triggered();
    void on_actionQuit_triggered();
    void resetParams();
    void getData();
    void errorHandler(QString error);
    void statusHandler(QString status);
    void on_reload_clicked();
    void on_spinBox_duration_valueChanged(int arg1);

    void on_spinBox_factor_valueChanged(int arg1);

    void on_spinBox_fps_valueChanged(int arg1);

    void on_spinBox_dimension_valueChanged(int arg1);

private:
    Ui::a2a *ui;
    Sox audio;
    QString active;
};

#endif // A2A_H

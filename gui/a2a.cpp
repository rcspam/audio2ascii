#include "a2a.h"
#include "ui_a2a.h"

a2a::a2a(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::a2a)
{
    ui->setupUi(this);
    setWindowTitle(qApp->applicationName()+" "+qApp->applicationVersion());
}

a2a::~a2a()
{
    delete ui;
}

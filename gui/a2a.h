#ifndef A2A_H
#define A2A_H

#include <QMainWindow>

namespace Ui {
class a2a;
}

class a2a : public QMainWindow
{
    Q_OBJECT

public:
    explicit a2a(QWidget *parent = 0);
    ~a2a();

private:
    Ui::a2a *ui;
};

#endif // A2A_H

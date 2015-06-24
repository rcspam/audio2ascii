#include <QApplication>
#include "a2a.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QCoreApplication::setApplicationName("audio2ascii");
    QCoreApplication::setApplicationVersion("1.0alpha1");
    a2a w;
    w.show();

    return a.exec();
}

#include <QApplication>
#include "a2a.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QCoreApplication::setApplicationName("audio2ascii");
    QCoreApplication::setOrganizationName("audio2ascii");
    QCoreApplication::setApplicationVersion(A2A_VERSION);
    a2a w;
    w.show();

    return a.exec();
}

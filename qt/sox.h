#ifndef SOX_H
#define SOX_H

#include <QObject>

class Sox : public QObject
{
    Q_OBJECT
public:
    explicit Sox(QObject *parent = 0);

signals:
    void error(QString msg);
    void status(QString msg);

public slots:
    QString bin(bool info);
    QString about();
    int samplerate(QString filename);
    QString dat(QString filename, int fps, int duration, int factor, int dimension);
};

#endif // SOX_H

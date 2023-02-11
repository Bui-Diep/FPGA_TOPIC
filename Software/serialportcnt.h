#ifndef SERIALPORTCNT_H
#define SERIALPORTCNT_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>

class serialportcnt : public QObject
{
public:
    explicit serialportcnt(QObject *parent =nullptr);
    QList<QSerialPortInfo> getAvailiblePorts();
    bool begin(QString portnamez,int baudz, int databitz,int parityz, int stopbitz,int flowctrlz,bool dtrOn);
    bool begin(QString portnamez,qint32 baudz, QString databitz,QString parityz, QString stopbitz,QString flowctrlz,bool dtrOn);
    bool end();
    bool send(QString data);
    bool send(const QByteArray data);
    bool recevei();
    QString setSerialInfo();
    QString readAll();
private:
    QSerialPort *serialDevice;

};

#endif // SERIALPORTCNT_H

#include "serialportcnt.h"

serialportcnt::serialportcnt(QObject *parent): QObject(parent)
{
    serialDevice = new QSerialPort(this);
}
QList<QSerialPortInfo> serialportcnt::getAvailiblePorts()
{
    return  QSerialPortInfo::availablePorts();
}

bool serialportcnt::begin(QString portnamez, int baudz, int databitz, int parityz, int stopbitz, int flowctrlz, bool dtrOn)
{
    this ->serialDevice->setPortName(portnamez);

    if(!serialDevice->isOpen())
    {
        if(serialDevice->open(QSerialPort::ReadWrite))
        {
            this->serialDevice->clear();
            this->serialDevice->setBaudRate(baudz);
            this->serialDevice->setDataBits((QSerialPort::DataBits)databitz);
            this->serialDevice->setParity((QSerialPort::Parity)parityz);
            this->serialDevice->setStopBits((QSerialPort::StopBits)stopbitz);
            this->serialDevice->setFlowControl((QSerialPort::FlowControl)flowctrlz);
            //this->serialDevice->set
            this->serialDevice->setDataTerminalReady(dtrOn);
            connect(this->serialDevice,SIGNAL(readyRead()), this, SLOT(readString()));

            return true;
        }
        return false;
    }
    else return false;
}

bool serialportcnt::begin(QString portnamez, qint32 baudz, QString databitz, QString parityz, QString stopbitz, QString flowctrlz, bool dtrOn)
{
    this->serialDevice->setPortName(portnamez);

    if (!serialDevice->isOpen())
    {
        if (serialDevice->open(QSerialPort::ReadWrite))
        {
            this->serialDevice->clear();
            this->serialDevice->setBaudRate(baudz);

            if (databitz.contains("Data5"))
                this->serialDevice->setDataBits(QSerialPort::DataBits::Data5);
            else if (databitz.contains("Data6"))
                this->serialDevice->setDataBits(QSerialPort::DataBits::Data6);
            else if (databitz.contains("Data7"))
                this->serialDevice->setDataBits(QSerialPort::DataBits::Data7);
            else if (databitz.contains("Data8"))
                this->serialDevice->setDataBits(QSerialPort::DataBits::Data8);

            if (parityz.contains("NoParity"))
                this->serialDevice->setParity(QSerialPort::Parity::NoParity);
            else if (parityz.contains("EvenParity"))
                this->serialDevice->setParity(QSerialPort::Parity::EvenParity);
            else if (parityz.contains("OddParity"))
                this->serialDevice->setParity(QSerialPort::Parity::OddParity);
            else if (parityz.contains("SpaceParity"))
                this->serialDevice->setParity(QSerialPort::Parity::SpaceParity);
            else if (parityz.contains("MarkParity"))
                this->serialDevice->setParity(QSerialPort::Parity::MarkParity);

            if (stopbitz.contains("OneStop"))
                this->serialDevice->setStopBits(QSerialPort::StopBits::OneStop);
            else if (stopbitz.contains("OneAndHalfStop"))
                this->serialDevice->setStopBits(QSerialPort::StopBits::OneAndHalfStop);
            else if (stopbitz.contains("TwoStop"))
                this->serialDevice->setStopBits(QSerialPort::StopBits::TwoStop);

            if (flowctrlz.contains("NoFlowControl"))
                this->serialDevice->setFlowControl(QSerialPort::FlowControl::NoFlowControl);
            else if (flowctrlz.contains("HardwareControl"))
                this->serialDevice->setFlowControl(QSerialPort::FlowControl::HardwareControl);
            else if (flowctrlz.contains("SoftwareControl"))
                this->serialDevice->setFlowControl(QSerialPort::FlowControl::SoftwareControl);

            this->serialDevice->setDataTerminalReady(dtrOn);

            //  I have identified that the problem is due to the EDBG chip (usb-serial bridge) which requires DTR signal to enable the serial port RXD and TXD pins.
            //  Including the line of code "serial->setDataTerminalReady(true);" after opening the serial port, the serial port application is now working fine. I guess this is automatically carried out on hyper-terminal software and tera-term software.
            //  Whether the communication uses the flow control or not,some of the hardware bridge requires the flow control signals to be set for the first time after power ON.

            connect(this->serialDevice, SIGNAL(readyRead()), this, SLOT(readString()));

            return true;
        }
        return false;
    }
    else
    {
        return false;
    }
}

bool serialportcnt::end()
{
    disconnect(serialDevice, SIGNAL(readyRead()), this, SLOT(readString()));

    serialDevice->clear();
    serialDevice->close();
    if (!this->serialDevice->isOpen())
        return true;
    else
        return false;
}

bool serialportcnt::send(QString data)
{
    if(this->serialDevice->isOpen() && this->serialDevice->isWritable())
    {
        this->serialDevice->write(data.toStdString().c_str());
        return true;
    }
    else    return false;
}

bool serialportcnt::send(const QByteArray data)
{
    if(this->serialDevice->isOpen() && this->serialDevice->isWritable())
    {
        this->serialDevice->write(data);
        return true;
    }
    else    return false;
}

bool serialportcnt::recevei()
{
    if(this->serialDevice->isOpen() && this->serialDevice->waitForBytesWritten(300))
    {
        return true;
    }
    else    return false;
}

QString serialportcnt::setSerialInfo()
{
    QString outputString;
    outputString.append(serialDevice->portName() + ", " + QString::number(serialDevice->baudRate()) + ", ");

    switch (serialDevice->dataBits())
    {
    case (QSerialPort::DataBits::Data5):
        outputString.append("Data5, ");
        break;
    case (QSerialPort::DataBits::Data6):
        outputString.append("Data6, ");
        break;
    case (QSerialPort::DataBits::Data7):
        outputString.append("Data7, ");
        break;
    case (QSerialPort::DataBits::Data8):
        outputString.append("Data8, ");
        break;
    case (QSerialPort::DataBits::UnknownDataBits):
        outputString.append("UnknownDataBits, ");
        break;
    }

    switch (serialDevice->parity())
    {
    case (QSerialPort::Parity::NoParity):
        outputString.append("NoParity, ");
        break;
    case (QSerialPort::Parity::OddParity):
        outputString.append("OddParity, ");
        break;
    case (QSerialPort::Parity::EvenParity):
        outputString.append("EvenParity, ");
        break;
    case (QSerialPort::Parity::MarkParity):
        outputString.append("MarkParity, ");
        break;
    case (QSerialPort::Parity::SpaceParity):
        outputString.append("SpaceParity, ");
        break;
    case (QSerialPort::Parity::UnknownParity):
        outputString.append("UnknownParity, ");
        break;
    }

    switch (serialDevice->stopBits())
    {
    case (QSerialPort::StopBits::OneStop):
        outputString.append("OneStop, ");
        break;
    case (QSerialPort::StopBits::TwoStop):
        outputString.append("TwoStop, ");
        break;
    case (QSerialPort::StopBits::OneAndHalfStop):
        outputString.append("OneAndHalfStop, ");
        break;
    case (QSerialPort::StopBits::UnknownStopBits):
        outputString.append("UnknownStopBits, ");
        break;
    }

    switch (serialDevice->flowControl())
    {
    case (QSerialPort::FlowControl::NoFlowControl):
        outputString.append("NoFlowControl, ");
        break;
    case (QSerialPort::FlowControl::HardwareControl):
        outputString.append("HardwareControl, ");
        break;
    case (QSerialPort::FlowControl::SoftwareControl):
        outputString.append("SoftwareControl, ");
        break;
    case (QSerialPort::FlowControl::UnknownFlowControl):
        outputString.append("UnknownFlowControl, ");
        break;
    }

    // outputString.append("DTR: " + QSerialPort::DataTerminalReadySignal);

    return outputString;
}

QString serialportcnt::readAll()
{
    return this->serialDevice->readAll();
}

#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    setWindowTitle("Text System");
    CreateBase();
    //connect(ui->lineEditsend->text(),SIGNAL(returnPressed()), this, SLOT(on_comboBoxSendReturnPressedSlot()));}
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::addMess(QString text, bool agrT)
{
    if(false) // Sau nay co the gan vao button de bat/tat chuc nang nay
    {
        if(!agrT)
        {
              ui->textBrowser->append(text);
        }
    }
    else
    {
        ui->textBrowser->append(text);
    }
}

//Ham tao co so thoi gian cho APP
void MainWindow::CreateBase()
{
    this->serialDeviceTimer = new QTimer(this);
    this->radioButtonTimer = new QTimer(this);
    this->serialStingProcessTimer = new QTimer(this);
    this->upStringProcessingTimer = new QTimer(this);

    connect(serialStingProcessTimer,SIGNAL(timeout()), this, SLOT(on_pushButton_clicked));
    connect(radioButtonTimer, &QTimer::timeout,this, [=](){ui->radioButton->setCheckable(false);});


}

//Ham bao cho ui->TextBrower khi truyen data qua COM
void MainWindow::serialsend(QString messenger)
{

    if (!serialcnt.send(messenger))
        this->addMess("App >>\t Unable to send! Serial port closed !", true);
    else
    {
        sendMessSerial();
        saveFile("TextSample.txt");
    }
}

void MainWindow::sendMessSerial()
{
    QString datasends = ui->lineEditsend->text();
    addMess("\n >>" +datasends,true);
}

void MainWindow::saveFile(QString const fileSave)
{
    QFile file(fileSave);

    if(file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        if(serialcnt.recevei()){
            QString datasave = serialcnt.readAll();
           // upStringProcessingTimer->start(1000);
            QTextStream stream(&file);
            stream << datasave;
            addMess("Nhan duoc: "+ datasave + " || hoan thien",true);
        }
        addMess("\n Saved at file: " + fileSave , true);

    }

}

//QString portnamez,qint32 baudz, QString databitz,
//QString parityz, QString stopbitz,QString flowctrlz,bool dtrOn
void MainWindow::on_pushButton_uart_clicked()
{
   QString portnamez = QSerialPortInfo::availablePorts().at(ui->comboBox->currentIndex()).portName();
   uint baudz = ui->comboBox_baud->currentText().toInt();
   QString databitz = ui->comboBox_databit ->currentText();
   QString parityz = ui->comboBox_partiy->currentText();
   QString bitstopz = ui->comboBox_bitstop->currentText();
   QString flowctrlz = ui->comboBox_flowcontrol->currentText();

//show thong tin ket noi taij label_messUart

   ui->label_mesUart->setText(portnamez+ ",Baud: "+ui->comboBox_baud->currentText()+ ",dataBit: "+
                              databitz+ ", Bitstop:"+ bitstopz+ ", flowctrl:"+ flowctrlz);
   if(serialcnt.begin(portnamez,baudz,databitz,parityz,bitstopz,flowctrlz,ui->checkBoxDTR->isChecked()))
   {
       serialStingProcessTimer->start(1000); //cho simulink

       connect(serialStingProcessTimer, SIGNAL(timeout()), this, SLOT(on_processSerial()));
       ui->pushButton_uart->setText("Disconnect");
       //addMess(); phan trong ham dung cho label_mesUart

   }
   else
   {
       serialStingProcessTimer ->stop();
       disconnect(serialStingProcessTimer, SIGNAL(timeout()), this, SLOT(on_processSerial()));

       if(serialcnt.end())
       {
            ui->pushButton_uart->setText("connect");
       }
       else
       {
           ui->pushButton_uart->setCheckable(true);
       }
       if(!ui->pushButton_uart->isCheckable())
       {
           // dong file
           qDebug() << "Dong chuc nang file";
       }
   }

}

//Ham check cac cong COM dang co voi nut radiobutton duoc nhap lan dau
void MainWindow::on_radioButton_toggled(bool checked) //chua dung bool cheched
{
    QList<QSerialPortInfo> device = serialcnt.getAvailiblePorts();
    QList<QString> portName;
    static QList<QString> portNameOld;

    ui->radioButton->animateClick(500);

    foreach (auto item, device)
        portName.append(item.portName());
    if (device.count() >= 1)
    {
        ui->comboBox->clear();

        for (auto i = 0; i < device.count(); ++i)
        {
            ui->comboBox->addItem("(" + device.at(i).portName() + ")" );
            ui->radioButton->setDown(true);
        }
    }
    else if ((device.count() < 1) && !ui->comboBox->itemText(0).startsWith("No COM devices"))
    {
        ui->comboBox->clear();
        ui->comboBox->addItem("No serial devices detected :(");
        ui->comboBox->setCurrentIndex(ui->comboBox->count() - 1);
        ui->radioButton->setDown(false);
    }

}

//Button cho phep gui data qua COM dang ket noi
void MainWindow::on_pushButton_gui_clicked()
{
    QString datasend = ui->lineEditsend->text();
    serialsend(datasend);
}


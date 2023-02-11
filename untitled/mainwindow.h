#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSerialPort>
#include <QSerialPortInfo>

#include <QCloseEvent>
#include <QCompleter>
#include <QDateTime>
#include <QElapsedTimer>
#include <QFile>
#include <QFileDialog>
#include <QKeyEvent>
#include <QList>
#include <QMainWindow>
#include <QMessageBox>
#include <QMetaType>
#include <QPaintDevice>
#include <QRandomGenerator>
#include <QScrollBar>
#include <QSettings>
#include <QShortcut>
#include <QtDebug>
#include <QTextEdit>
#include <QTextStream>
#include <QTime>
#include <QTimer>


#include "serialportcnt.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    void addMess(QString text, bool agrT);

private slots:
    void on_pushButton_uart_clicked();

    void on_radioButton_toggled(bool checked);

    void on_pushButton_gui_clicked();

private:
    Ui::MainWindow *ui;
    QFile *filecnt;
    serialportcnt serialcnt;
    QTimer *serialDeviceTimer;
    QTimer *radioButtonTimer;
    QTimer *upStringProcessingTimer;
    QTimer *serialStingProcessTimer;

    void CreateBase();
    void serialsend(QString messenger);
    void sendMessSerial();
    void saveFile(QString const fileSave);
};
#endif // MAINWINDOW_H

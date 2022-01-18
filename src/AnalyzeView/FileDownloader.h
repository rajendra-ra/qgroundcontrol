#ifndef FILEDOWNLOADER_H
#define FILEDOWNLOADER_H

#include <QObject>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QtWidgets>
#include <QtNetwork>
//Q_DECLARE_METATYPE(QStringList*)

class FileDownloader : public QObject
{
    Q_OBJECT
public:
    explicit FileDownloader();
    virtual ~FileDownloader();
    Q_PROPERTY(bool isBusy READ isBusy NOTIFY isBusyChanged)
    Q_PROPERTY(QStringList indexList READ indexList NOTIFY indexListChanged)
    Q_INVOKABLE void startDownload(QUrl url, QString fileName);
    Q_INVOKABLE void startDownloadIndex(QUrl url);
    void abortDownload();
    QStringList indexList(){return _indexList;}
//    QStringListModel* model(){return _model;}
    bool isBusy();
//    void download(QUrl imageUrl);
//    float getProgress();
//    QByteArray downloadedData() const;

    //connect to the following signals to get information about the ongoing download
    Q_SIGNAL void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    Q_SIGNAL void downloadSuccessful();
    Q_SIGNAL void indexingSuccessful();
    Q_SIGNAL void downloadError(QString errorString);
    Q_SIGNAL void selected(QString errorString);
    //the next two signals are used to indicate transitions between busy and
    //ready states of the file downloader, they can be used to update the GUI
    Q_SIGNAL void goingBusy();
    Q_SIGNAL void backReady();
    Q_SIGNAL void indexListChanged(QStringList indexList);
    Q_SIGNAL void isBusyChanged(bool isBusy);
private:
    Q_SLOT void readData();
    Q_SLOT void makeReady();
    Q_SLOT void makeBusy();
    Q_SLOT void finishDownload();
    Q_SLOT void finishIndexing();
    //private function, cleans things up when the download is aborted
    //(due to an error or user interaction)
    void a_abortDownload();

    QNetworkAccessManager* nam;
    QUrl downloadUrl;
    QFile destinationFile;
    QPointer<QNetworkReply> networkReply;
    bool _busy = false;
    QStringList _indexList;
//    QStringListModel *_model;

};

#endif // FILEDOWNLOADER_H

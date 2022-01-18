#include "FileDownloader.h"

FileDownloader::FileDownloader()
    :nam(nullptr)
{
    connect(this, &FileDownloader::backReady,
            this, &FileDownloader::makeReady);
    connect(this, &FileDownloader::goingBusy,
            this, &FileDownloader::makeBusy);
}
FileDownloader::~FileDownloader(){
    //destructor cancels the ongoing dowload (if any)
    if(networkReply){
        a_abortDownload();
        nam->deleteLater();
    }
}
void FileDownloader::makeReady(){
    _busy = false;
    emit isBusyChanged(_busy);
}
void FileDownloader::makeBusy(){
    _busy = true;
    emit isBusyChanged(_busy);
}
bool FileDownloader::isBusy(){
    return _busy;
}
void FileDownloader::abortDownload(){
    if(!networkReply) return;
    a_abortDownload();
    emit backReady();
}
void FileDownloader::readData(){
    QByteArray data= networkReply->readAll();
    destinationFile.write(data);
}
void FileDownloader::finishDownload(){
    if(networkReply->error() != QNetworkReply::NoError){
        //failed download
        a_abortDownload();
        emit downloadError(networkReply->errorString());
    } else {
        //successful download
        QByteArray data= networkReply->readAll();
        destinationFile.write(data);
        destinationFile.close();
        networkReply->deleteLater();
        emit downloadSuccessful();
    }
    emit backReady();
}
void FileDownloader::finishIndexing(){
//    return;
    if(networkReply->error() != QNetworkReply::NoError){
        //failed download
        networkReply->abort();
        networkReply->deleteLater();
        emit downloadError(networkReply->errorString());
    } else {
        //successful download
        QByteArray data= networkReply->readAll();
        QString html = QString(data);

        QRegularExpression re("<a href=\"(.*?)\">");
        QRegularExpressionMatchIterator i = re.globalMatch(html);
        _indexList.clear();
        while (i.hasNext()) {
            QRegularExpressionMatch match = i.next();
    //        qDebug().noquote() << match.captured();
            _indexList << match.captured(1);
        }
        emit indexListChanged(_indexList);

//        _model->setStringList(_indexList);


//        destinationFile.write(data);
//        destinationFile.close();
//        cout<<data.toStdString();

        networkReply->deleteLater();
        emit indexingSuccessful();
    }
    emit backReady();
}
void FileDownloader::a_abortDownload(){
    networkReply->abort();
    networkReply->deleteLater();
    destinationFile.close();
    destinationFile.remove();
}
void FileDownloader::startDownload(QUrl url, QString fileName){
    if(networkReply) return;
    if(isBusy()) return;
    destinationFile.setFileName(fileName);
    if(!destinationFile.open(QIODevice::WriteOnly)) return;
    emit goingBusy();
    QNetworkRequest request(url);
    networkReply= nam->get(request);
    connect(networkReply, &QIODevice::readyRead, this, &FileDownloader::readData);
    connect(networkReply, &QNetworkReply::downloadProgress,
            this, &FileDownloader::downloadProgress);
    connect(networkReply, &QNetworkReply::finished,
            this, &FileDownloader::finishDownload);
}
void FileDownloader::startDownloadIndex(QUrl url){
    if(!nam){
        nam = new QNetworkAccessManager();
    }
    if(networkReply) return;
    if(isBusy()) return;
//    destinationFile.setFileName(fileName);
//    if(!destinationFile.open(QIODevice::WriteOnly)) return;
    emit goingBusy();
    QNetworkRequest request(url);
    networkReply= nam->get(request);
//    connect(networkReply, &QIODevice::readyRead, this, &FileDownloader::readData);
    connect(networkReply, &QNetworkReply::downloadProgress,
            this, &FileDownloader::downloadProgress);
    connect(networkReply, &QNetworkReply::finished,
            this, &FileDownloader::finishIndexing);
}

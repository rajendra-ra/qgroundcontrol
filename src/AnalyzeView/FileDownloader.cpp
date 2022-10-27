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
    //destructor cancels the ongoing download (if any)
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
    if(networkReply->error() != QNetworkReply::NoError){
        //if failed to download index file
        networkReply->abort();
        networkReply->deleteLater();
        emit downloadError(networkReply->errorString());
    } else {
        //if successfully downloaded index file
        QByteArray data= networkReply->readAll();
        QString html = QString(data);
        // regex to detect file links
        QRegularExpression re("<td><a href=\"(.*?)\">(.*?)</a></td>");
        QRegularExpressionMatchIterator i = re.globalMatch(html);
        // clear previous index list
        _indexList.clear();
        QString base = networkReply->url().toString();
        baseUrl.setUrl(base);
        // append all files to list
        while (i.hasNext()) {
            QRegularExpressionMatch match = i.next();
            QString name = match.captured(1);
            bool isdir = false;
            if(name.endsWith("/")){
                name = name.remove("/");
                isdir = true;
            }
            LogEntry *entry = new LogEntry(base,name,isdir);
            _indexList.append(entry);
        }
        emit indexListChanged(&_indexList);
        networkReply->deleteLater();
        emit indexingSuccessful(base);
    }
    emit backReady();
}
void FileDownloader::a_abortDownload(){
    // close connection
    networkReply->abort();
    networkReply->deleteLater();
    // close file
    destinationFile.close();
    destinationFile.remove();
}
void FileDownloader::startDownload(QUrl url, QString fileName){
    if(!nam){
        nam = new QNetworkAccessManager(); // init network manager if not already
    }
    if(isBusy()) return; // do nothin if busy
    // get parent directory of file
    QStringList _list =  fileName.split("/");
    _list.removeLast();
    QDir dir(_list.join("/"));
    // check if directory exists else make it
    if (!dir.exists())
        dir.mkpath(".");
    // ready file to store download data
    destinationFile.setFileName(fileName);
    if(!destinationFile.open(QIODevice::WriteOnly)) return;
    emit goingBusy(); // set status busy
    QNetworkRequest request(url); // make download request
    networkReply= nam->get(request); //  send request
    if(!networkReply) return; // todo: need to notify used of failure

    connect(networkReply, &QIODevice::readyRead, this, &FileDownloader::readData);
    // monitor download progress
    connect(networkReply, &QNetworkReply::downloadProgress,
            this, &FileDownloader::downloadProgress);
    connect(networkReply, &QNetworkReply::finished,
            this, &FileDownloader::finishDownload);
}
void FileDownloader::startDownloadIndex(QUrl url){
    if(!nam){
        nam = new QNetworkAccessManager(); // init network manager if not already
    }
    if(isBusy()) return; // do nothing if already busy
    emit goingBusy(); // set busy
    QNetworkRequest request(url); // make request
    networkReply= nam->get(request); // send request
    if(!networkReply) return; // check if got response
    // setup signal and callbacks
    connect(networkReply, &QNetworkReply::downloadProgress,
            this, &FileDownloader::downloadProgress);
    connect(networkReply, &QNetworkReply::finished,
            this, &FileDownloader::finishIndexing);
}

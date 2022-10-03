#include "logentry.h"

LogEntry::LogEntry(QString baseUrl, QString name, bool isDir)
    : _baseUrl(baseUrl)
    , _isDir(isDir)
    , _selected(false)
    , _name(name)
{

}
QString
LogEntry::url()
{   // get file's url
    // if url is for directory then append `/` to end of url
    QString _sep = "";
    if(_isDir){
        _sep = "/";
    }
    return QString("%1%2%3").arg(_baseUrl,_name,_sep);
}

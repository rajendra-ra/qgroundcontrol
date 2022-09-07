#pragma once
#include <QStringBuilder>
#include <QObject>
#include <QDateTime>

class LogEntry : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString      baseUrl     READ baseUrl    WRITE setBaseUrl    NOTIFY baseUrlChanged)
    Q_PROPERTY(bool         isDir       READ isDir      WRITE setAsDir      NOTIFY typeChanged)
    Q_PROPERTY(bool         selected    READ selected   WRITE setSelected   NOTIFY selectedChanged)
    Q_PROPERTY(QString      name        READ name       WRITE setName       NOTIFY nameChanged)
    Q_PROPERTY(QString      fullname    READ fullname                       NOTIFY nameChanged)
    Q_PROPERTY(QString      url         READ url        NOTIFY baseUrlChanged)


public:
    LogEntry(QString baseUrl, QString name, bool isDir = false);

    QString     baseUrl  () const { return _baseUrl; }
    bool        isDir    () const { return _isDir; }
    bool        selected () const { return _selected; }
    QString     name     () const { return _name; }
    QString     fullname() const {
        QString _sep = "";
        if(_isDir)_sep = "/";
        return _name + _sep;
    }
    QString     url      ();

    void        setBaseUrl  (QString baseUrl_)     { _baseUrl = baseUrl_;     emit baseUrlChanged(); }
    void        setAsDir    (bool dir_)         { _isDir = dir_;     emit typeChanged(); }
    void        setSelected (bool sel_)         { _selected = sel_;     emit selectedChanged(); }
    void        setName     (QString name_)     { _name = name_;      emit nameChanged(); }

signals:
    void        baseUrlChanged  ();
    void        typeChanged     ();
    void        selectedChanged ();
    void        nameChanged     ();

private:
    QString     _baseUrl;
    bool        _isDir;
    bool        _selected;
    QString     _name;
};

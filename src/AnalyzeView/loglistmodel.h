#pragma once
#include <QQmlEngine>
#include <QAbstractListModel>
#include "logentry.h"

class LogListModel : public QAbstractListModel
{
    Q_OBJECT
public:

    enum LogListModelRoles {
        PathRole = Qt::UserRole + 1
    };

    LogListModel(QObject *parent = nullptr);
    // make count value accesible from ui
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    // get an indexed item from the list
    Q_INVOKABLE LogEntry* get(int index);

    int         count           (void) const;       // count number of items in list
    void        append          (LogEntry* entry);  // add item tyo list
    void        clear           (void);             // clear list
    LogEntry*operator[]         (int i);            // get item usin index operator

    int         rowCount        (const QModelIndex & parent = QModelIndex()) const;
    QVariant    data            (const QModelIndex & index, int role = Qt::DisplayRole) const; // data of the item

signals:
    void        countChanged    ();

protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<LogEntry*> _logEntries;
};

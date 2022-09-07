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

    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_INVOKABLE LogEntry* get(int index);

    int         count           (void) const;
    void        append          (LogEntry* entry);
    void        clear           (void);
    LogEntry*operator[]      (int i);

    int         rowCount        (const QModelIndex & parent = QModelIndex()) const;
    QVariant    data            (const QModelIndex & index, int role = Qt::DisplayRole) const;

signals:
    void        countChanged    ();

protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<LogEntry*> _logEntries;
};

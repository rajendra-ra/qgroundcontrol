#include "loglistmodel.h"

LogListModel::LogListModel(QObject *parent)
    : QAbstractListModel{parent}
{

}
LogEntry*
LogListModel::get(int index)
{
    if (index < 0 || index >= _logEntries.count()) {
        return nullptr;
    }
    return _logEntries[index];
}
int
LogListModel::count() const
{
    return _logEntries.count();
}
void
LogListModel::append(LogEntry* object)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    QQmlEngine::setObjectOwnership(object, QQmlEngine::CppOwnership);
    _logEntries.append(object);
    endInsertRows();
    emit countChanged();
}
void
LogListModel::clear(void)
{
    if(!_logEntries.isEmpty()) {
        beginRemoveRows(QModelIndex(), 0, _logEntries.count());
        while (_logEntries.count()) {
            LogEntry* entry = _logEntries.last();
            if(entry) entry->deleteLater();
            _logEntries.removeLast();
        }
        endRemoveRows();
        emit countChanged();
    }
}
LogEntry*
LogListModel::operator[](int index)
{
    return get(index);
}
int
LogListModel::rowCount(const QModelIndex& /*parent*/) const
{
    return _logEntries.count();
}
QVariant
LogListModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= _logEntries.count())
        return QVariant();
    if (role == PathRole){
        auto entry = _logEntries[index.row()];
        return QVariant(entry->fullname());
//        return QVariant::fromValue(_logEntries[index.row()]);
    }
    return QVariant();
}
QHash<int, QByteArray>
LogListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[PathRole] = "Path";
    return roles;
}

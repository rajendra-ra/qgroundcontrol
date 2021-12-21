import QtQuick 2.0
import QtQml.Models 2.15
import QtPositioning 5.0

ListModel {
    Component.onCompleted: {
        append({"name":"Location A","coordinate":QtPositioning.coordinate(13.12122,77.04541)});
        append({"name":"Location B","coordinate":QtPositioning.coordinate(13.12122,77.04541)});
        append({"name":"Location C","coordinate":QtPositioning.coordinate(13.12122,77.04541)});
        append({"name":"Location D","coordinate":QtPositioning.coordinate(13.12122,77.04541)});
        append({"name":"Location E","coordinate":QtPositioning.coordinate(13.12122,77.04541)});
        append({"name":"Location F","coordinate":QtPositioning.coordinate(13.12122,77.04541)});
    }
}


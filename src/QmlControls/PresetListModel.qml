import QtQuick 2.0
import QtQml.Models 2.15
import QtPositioning 5.0

ListModel {
    Component.onCompleted: {
        append({"name":"Location A","coordinate":QtPositioning.coordinate(13.1111,77.1111,10)});
        append({"name":"Location B","coordinate":QtPositioning.coordinate(13.2222,77.2222,20)});
        append({"name":"Location C","coordinate":QtPositioning.coordinate(13.3333,77.3333,30)});
        append({"name":"Location D","coordinate":QtPositioning.coordinate(13.4444,77.4444,40)});
        append({"name":"Location E","coordinate":QtPositioning.coordinate(13.5555,77.5555,50)});
        append({"name":"Location F","coordinate":QtPositioning.coordinate(13.6666,77.6666,60)});
    }
}


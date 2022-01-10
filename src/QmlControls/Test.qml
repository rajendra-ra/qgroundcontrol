import QtQuick              2.12
import QtQuick.Controls     2.4
import QtQuick.Layouts      1.12
import QtQuick.Dialogs      1.3
import QtPositioning        5.12
import QGroundControl       1.0
import QGroundControl.Controls 1.0

Rectangle {
    id: rectangle
    width: 640
    height: 480
    color: "#2e3436"
    border.color: "black"

    TitleBoxContainer {
        titleColor: "gray"
        titleTextColor: "white"
        unit: "m"

    }
}




import QtQml.Models 2.15
import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.2

Item {
    id:_root
    property real cornerRadius:100
    property int corner: Qt.BottomLeftCorner
    property string cornerColor: "#7a0d0d"
    height: cornerRadius*0.5
    clip: true
    antialiasing: true
    width:cornerRadius*0.5
    Component.onCompleted: {
        console.log(Qt.BottomLeftCorner === corner)
    }

    Rectangle {
        id:_bottomLeftCorner
        height: cornerRadius
        width: height
        radius:cornerRadius
        border.color: "#00000000"
        border.width: 0
        antialiasing: true
        color: cornerColor
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.right
        visible: Qt.BottomLeftCorner === corner
    }
    Rectangle {
        id:_topLeftCorner
        height: cornerRadius
        width: height
        radius:cornerRadius
        border.color: "#00000000"
        border.width: 0
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.right
        antialiasing: true
        color: cornerColor
        visible: Qt.TopLeftCorner === corner
    }
    Rectangle {
        id:_bottomRightCorner
        height: cornerRadius
        width: height
        radius:cornerRadius
        border.color: "#00000000"
        border.width: 0
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.left
        antialiasing: true
        color: cornerColor
        visible: Qt.BottomRightCorner === corner
    }
    Rectangle {
        id:_topRightCorner
        height: cornerRadius
        width: height
        radius:cornerRadius
        border.color: "#00000000"
        border.width: 0
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.left
        antialiasing: true
        color: cornerColor
        visible: Qt.TopRightCorner === corner
    }
}



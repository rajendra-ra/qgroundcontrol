import QtQml.Models 2.15
import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.2

Rectangle {
    id: rectangle
    radius: 5
    color: "#00ffffff"
    property string titleColor: "orange"
    property string foregroundColor: "white"
    property string textColor: "black"
    property string titleTextColor: "white"
    property string title: "test"
    property string name: "name"
    property string unit: "m"
    property real altitude: 0
    ColumnLayout {
        anchors.fill:parent
        spacing: 0
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: titleColor
            radius: 5
            border.width: 0
            ColumnLayout {
                anchors.fill:parent
                spacing: 0
                anchors.margins: 1
                Label {
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    text: title
                    color: titleTextColor
                    background: Rectangle {
                        color: titleColor
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    border.width: 0
                    layer.enabled: false
                    radius: 5
                    color: foregroundColor
                    GridLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        columns: 2
                        Label {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.column: 0
                            Layout.row: 0
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text:"Name"
                            color: textColor
                        }
                        Label {
                            Layout.column: 1
                            Layout.row: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text: name
                            color: textColor
                        }
                        Label {
                            Layout.column: 0
                            Layout.row: 1
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text: "Altitude"
                            color: textColor
                        }
                        Label {
                            Layout.column: 1
                            Layout.row: 1
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text: altitude + " " + unit
                            color: textColor
                        }
                    }
               }
            }

        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:4}D{i:6}D{i:3}D{i:2}D{i:1}
}
##^##*/

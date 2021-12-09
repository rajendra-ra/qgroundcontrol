import QtQuick 2.0
import QtQuick.Layouts 1.3

Item {
    id: presetPanel
    property int _margin: 10
    width:640
    height: 480
    ColumnLayout {
        id:columnHolder
        anchors.fill: parent
        spacing:_margin
        GridLayout {
            Layout.fillWidth: true
            visible: true
            columns: 3
            columnSpacing: _margin
            rowSpacing: _margin

            Rectangle {
                Layout.rowSpan: 1
                Layout.columnSpan: 1
                color:"red"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Rectangle {
                Layout.rowSpan: 1
                Layout.columnSpan: 1
                color:"#0d1034"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Rectangle {
                Layout.rowSpan: 1
                Layout.columnSpan: 1
                color:"#41b184"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Rectangle {
                Layout.rowSpan: 1
                Layout.columnSpan: 1
                color:"#540885"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}D{i:3}D{i:4}D{i:5}D{i:6}D{i:2}D{i:1}
}
##^##*/

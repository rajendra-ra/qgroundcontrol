import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    clip: false
    Rectangle {
        id: rectangle
        color: "#2e3436"
        anchors.fill: parent

        ColumnLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: image
                width: 640
                source: "../ui/toolbar/Images/Analyze.svg"
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.preferredHeight: 100
                Layout.preferredWidth: 100
                antialiasing: true
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(72, 72)
            }

            Text {
                id: text1
                color: "#bfabab"
                text: "Post Flight"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: 27
                Layout.preferredWidth: 97
                textFormat: Text.RichText
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3;locked:true}D{i:4}D{i:2}D{i:1}
}
##^##*/

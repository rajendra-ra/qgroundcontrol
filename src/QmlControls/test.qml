import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Button {
    id: _rootButton
    visible: true
    clip: false
    activeFocusOnPress: true
    implicitHeight: __panel.implicitHeight
    onCheckedChanged: checkable = false
    style: ButtonStyle {
        background: Rectangle {
            id: rectangle
            color: "#2e3436"
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.bottomMargin: 0

            ColumnLayout {
                visible: true
                anchors.verticalCenter: parent.verticalCenter
                clip: true
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
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:480;width:640}
}
##^##*/


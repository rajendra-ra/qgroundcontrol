import QtQml.Models 2.15
import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.2
import QtPositioning    5.3

Rectangle {
    id: rectangle
    radius: 5
    color: "#00ffffff"
    property string titleColor: qgcPal.buttonHighlight
    property string foregroundColor: "black"
    property string textColor: "white"
    property string textEditColor: "black"
    property string titleTextColor: "white"
    property string title: "test"
    property string name: "name"
    property string unit: "m"
    property real textPadding: 1
    property int index
    property real altitude: 0
    property var location: QtPositioning.coordinate()
    property MouseArea ma:null
    ColumnLayout {
        anchors.fill:parent
        spacing: 0
        Rectangle {
            color: titleColor
            Layout.fillHeight: true
            Layout.fillWidth: true
            radius: 5
            border.width: 0
            clip: true
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
                        border.width: 0
                    }
                }
                Rectangle {
                    color: "#393939"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    layer.enabled: false
                    radius: 5
                    GridLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        columns: 3
                        Label {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.column: 0
                            Layout.row: 0
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text:"Name"
                            color: textColor
                            padding: textPadding
                        }
                        Label {
                            Layout.column: 1
                            Layout.row: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            Layout.columnSpan: 2
                            horizontalAlignment: Qt.AlignLeft
                            text: name
                            color: textColor
                            padding: textPadding
                        }
                        Label {
                            Layout.column: 0
                            Layout.row: 1
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text: "Location"
                            color: textColor
                            padding: textPadding
                        }
                        TextField {
                            id:_locationField
                            enabled: false
                            Layout.column: 1
                            Layout.row: 1
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            antialiasing: false
                            horizontalAlignment: Qt.AlignLeft
                            text: location.latitude + ", " + location.longitude
                            color: textEditColor
                            padding: textPadding
                            background: Rectangle {
                                color: foregroundColor
                                border.color: "transparent"
                                border.width: 1
                            }
                            onActiveFocusChanged: {
                                if(focus){
                                    background.border.color = "#21be2b"
//                                    console.log("TextField focus")
                                    ma.clicked(ma.mouseX,ma.mouseY)
                                } else {
                                    background.border.color = "transparent"
                                    valueChanged()
                                }
                            }
                            onAccepted: {focus = false}
                            function valueChanged(){
                                enabled = false;
                                var locationT = QtPositioning.coordinate();
                                text.split(',').forEach(function(item, index, array) {
                                  if(index===0){
                                    locationT.latitide = item.trim();
                                  } else if (index === 1){
                                    locationT.longitude = item.trim();
                                  }
                                })
                                if(locationT.isValid){
                                    console.log("valid location");
                                    location = locationT
                                }

                                console.log("location changed",text);
                            }
                        }
                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.column: 2
                            Layout.row: 1
                            Layout.fillHeight: true
                            display: AbstractButton.IconOnly
                            background: Image {
                                source:"qrc:/qmlimages/edit.svg"
                            }
                            onClicked: {
                                console.log("edit clicked")
                                _locationField.enabled = true
                                _locationField.focus = true
                                ma.clicked(ma.mouseX,ma.mouseY)
                            }
                        }
                        Label {
                            Layout.column: 0
                            Layout.row: 2
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text: "Altitude("+unit+")"
                            color: textColor
                            padding: textPadding
                        }
                        TextField {
                            id:_altitudeField
                            enabled: false
                            Layout.column: 1
                            Layout.row: 2
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignLeft
                            text: altitude
                            color: textEditColor
                            padding: textPadding
                            background: Rectangle {
                                color: foregroundColor
                                border.color: "transparent"
                                border.width: 1
                            }
                            onActiveFocusChanged: {
                                if(focus){
                                    background.border.color = "#21be2b"
                                    console.log("TextField focus")
                                    ma.clicked(ma.mouseX,ma.mouseY)
                                } else {
                                    background.border.color = "transparent"
                                    valueChanged()
                                }
                            }
                            onAccepted: {focus = false}
                            function valueChanged(){
                                enabled = false;
                                altitude=text.trim()*1.0
                            }
                        }
                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.column: 2
                            Layout.row: 2
                            Layout.fillHeight: true
                            display: AbstractButton.IconOnly
                            background: Image {
                                source:"qrc:/qmlimages/edit.svg"
                            }
                            onClicked: {
//                                console.log("edit clicked")
                                _altitudeField.enabled = true
                                _altitudeField.focus = true
                                ma.clicked(ma.mouseX,ma.mouseY)
                            }
                        }
                    }
               }
            }

        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:4}D{i:8}D{i:9}D{i:10}D{i:11}D{i:13}D{i:15}
D{i:16}D{i:18}D{i:7}D{i:6}D{i:3}D{i:2}D{i:1}
}
##^##*/

import QtQml.Models 2.15
import QtQuick 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.2
import QtPositioning    5.3

Rectangle {
    id: _root
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
                    font.pointSize: 14
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
                            font.pointSize: 14
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
                            font.pointSize: 14
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
                            font.pointSize: 14
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
                            text: focus?text:(location?location.latitude + ", " + location.longitude:"0,0")
                            color: textEditColor
                            font.pointSize: 14
                            padding: textPadding
                            background: Rectangle {
                                color: foregroundColor
                                border.color: "transparent"
                                border.width: 1
                            }
                            Binding {
                                target: _root
                                property: "location"
                                value: getValue()
                                function getValue(){
                                    let locationT = QtPositioning.coordinate();

                                    _locationField.text.split(',').forEach(function(item, index, array) {
                                        var lat,lon;
                                        if(index===0){
                                            locationT.latitude = item.trim()*1.0;
                                        } else if (index === 1){
                                            locationT.longitude = item.trim()*1.0;
                                        }
                                    })
                                    if(locationT.isValid){
                                        return locationT
    //                                    location = locationT
                                    } else {
                                        return location
                                    }

                                }
                            }
                            onTextChanged: {
                                //valueChanged()
                            }

                            onActiveFocusChanged: {
                                if(focus){
                                    background.border.color = "#21be2b"
                                    ma.clicked(ma.mouseX,ma.mouseY)
                                } else {
                                    background.border.color = "transparent"
                                    enabled = false
                                }
                            }
                            onAccepted: {focus = false}
                            /*function valueChanged(){
                                var locationT = QtPositioning.coordinate();

                                text.split(',').forEach(function(item, index, array) {
                                    var lat,lon;
                                    if(index===0){
                                        locationT.latitude = item.trim()*1.0;
                                    } else if (index === 1){
                                        locationT.longitude = item.trim()*1.0;
                                    }
                                })
                                if(locationT.isValid){
                                    location = locationT
                                }
                            }*/
                        }
                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.column: 2
                            Layout.row: 1
                            Layout.fillHeight: true
                            display: AbstractButton.IconOnly
//                            font.pointSize: 14
                            background: Image {
                                source:"qrc:/qmlimages/edit.svg"
                                sourceSize.height: height
                                fillMode: Image.PreserveAspectFit
                                sourceSize.width: width

                                width:height
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
                            font.pointSize: 14
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
                            font.pointSize: 14
                            color: textEditColor
                            padding: textPadding
                            background: Rectangle {
                                color: foregroundColor
                                border.color: "transparent"
                                border.width: 1
                            }
                            Binding {
                                target: _root
                                property: "altitude"
                                value: getValue()
                                function getValue(){
                                    let _altitude=_altitudeField.text.trim()*1.0
                                    return _altitude
                                }
                            }
                            onTextChanged: {
                                //valueChanged()
                            }
                            onActiveFocusChanged: {
                                if(focus){
                                    background.border.color = "#21be2b"
                                    ma.clicked(ma.mouseX,ma.mouseY)
                                } else {
                                    background.border.color = "transparent"
                                    enabled = false
                                }
                            }
                            onAccepted: {focus = false}
                            /*function valueChanged(){
                                altitude=text.trim()*1.0
                            }*/
                        }
                        Button {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            Layout.column: 2
                            Layout.row: 2
                            Layout.fillHeight: true
                            display: AbstractButton.IconOnly
                            background: Image {
                                source:"qrc:/qmlimages/edit.svg"
                                sourceSize.height: height
                                fillMode: Image.PreserveAspectFit
                                sourceSize.width: width
                                width:height
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
    D{i:0;autoSize:true;formeditorZoom:0.66;height:480;width:640}D{i:2}D{i:1}
}
##^##*/

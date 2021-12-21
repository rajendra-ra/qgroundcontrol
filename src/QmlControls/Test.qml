import QtQuick              2.12
import QtQuick.Controls     2.4
import QtQuick.Layouts      1.12
import QtQuick.Dialogs      1.3
import QtPositioning        5.12


Rectangle {
    id: rectangle
    width: 640
    height: 480
    color: "#2e3436"
    border.color: "black"

    ColumnLayout {
        anchors.fill: parent
        ColumnLayout {
            id: inputLayout
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            spacing: 2
            Layout.fillWidth: true
            Repeater {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                model: 2
                GridLayout {
                    columnSpacing: 1
                    rows: 1
                    columns: 2
                    rowSpacing: 1
                    Layout.fillWidth: true
                    Rectangle {
                        id: locationInputBox
                        Layout.row: 0
                        Layout.column: 0
                        radius: 3
                        border.width: 0
                        height: 40
                        width: childrenRect.width
                        Layout.fillWidth: true
                        z:0
                        Image {
                            id: locationImg
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.top: parent.top
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            source: "qrc:/qmlimages/location.svg"
                            mipmap: true
                            sourceSize.height: height
                            sourceSize.width: width
                            fillMode: Image.PreserveAspectFit
                        }
                        TextField {
                            id: locationInput
                            anchors.left: locationImg.right
                            anchors.right: parent.right
                            color: "gray"
                            horizontalAlignment: Text.AlignLeft
                            onPressed: {
                                dropdown.open()
                            }

                            onActiveFocusChanged: {
                                if (focus) {
                                    dropdown.open()
                                } else {
                                    dropdown.close()
                                }
                            }
                            onEditingFinished: {
                                dropdown.open()
                            }
                            Popup {
                                id:dropdown
                                modal: false
                                clip: true
                                y:parent.height
                                width:parent.width
                                padding: 10
                                closePolicy: Popup.CloseOnPressOutside
                                contentItem: ListView {
                                    property alias popup: dropdown
                                    maximumFlickVelocity: 1000
                                    implicitHeight: contentHeight
                                    model: presetModel
                                    delegate: presetDelegate
                                    anchors.fill:parent
                                    onCurrentIndexChanged: {
                                        locationInput.text = model.get(currentIndex).name
                                        dropdown.close()
                                    }

                                }
                            }
                        }

                    }

                    Rectangle {
                        id: altitudeInputBox
                        Layout.row: 0
                        Layout.column: 1
                        height: 40
                        width: childrenRect.width
                        radius: 5

                        Image {
                            id: altitudeImg
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.top: parent.top
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            source: "qrc:/qmlimages/Analyze.svg"
                            mipmap: true
                            sourceSize.height: height
                            sourceSize.width: width
                            fillMode: Image.PreserveAspectFit
                        }
                        TextField {
                            anchors.left: altitudeImg.right
                            color: "gray"
                            horizontalAlignment: Text.AlignLeft
                            Layout.fillWidth: true
                            placeholderText: "Altitude"
                            text: "50"
                        }
                    }
                }
            }
        }

        TestModel {
            id: presetModel
        }

        Component {
            id: presetDelegate
            Rectangle {
                id:_rootListDelegate
                width: parent.width
                height: childrenRect.height
                color: "white"
                border.color: "gray"
                RowLayout {
                    Text {
                        Layout.margins: 5
                        text: name
                        horizontalAlignment: TextField.AlignLeft
                        verticalAlignment: TextField.AlignVCenter
                    }
                    Text {
                        Layout.margins: 5
                        text: coordinate
                        horizontalAlignment: TextField.AlignLeft
                        verticalAlignment: TextField.AlignVCenter
                    }
                }
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: {
                        _rootListDelegate.color = "lightblue"
                    }
                    onExited: {
                        _rootListDelegate.color = "white"
                    }
                    onClicked: {
                        _rootListDelegate.ListView.view.currentIndex = index
                        _rootListDelegate.ListView.view.popup.close()
                    }
                }
            }
        }
    }
}




import QtQuick                      2.12
import QtQuick.Controls             2.4
import QtQuick.Layouts              1.12
import QtQuick.Dialogs              1.3
import QtQuick.Window 2.0
//import QGroundControl               1.0
//import QGroundControl.Controls      1.0
//import QGroundControl.Palette       1.0
//import QGroundControl.ScreenTools   1.0
Window {
Popup {
        id: _root
        anchors.centerIn:   parent
        width:              mainColumnLayout.width + (padding * 2)
        height:             mainColumnLayout.y + mainColumnLayout.height + padding
        padding:            2
        modal:              true
        focus:              true
        visible: true
        property real    _margin:            5
        property real   _frameSize:         10//ScreenTools.defaultFontPixelWidth
        property string _dialogTitle
        property real   _contentMargin:     5//ScreenTools.defaultFontPixelHeight / 2
        property real   _popupDoubleInset:  20//ScreenTools.defaultFontPixelHeight * 2
        property real   _maxContentWidth:   parent.width - _popupDoubleInset
        property real   _maxContentHeight:  parent.height - titleRowLayout.height - _popupDoubleInset
        background: Item {
            Rectangle {
                anchors.left:   parent.left
                anchors.top:    parent.top
                width:          _frameSize
                height:         _frameSize
                color:          "black"
                visible:        true
            }

            Rectangle {
                anchors.right:  parent.right
                anchors.top:    parent.top
                width:          _frameSize
                height:         _frameSize
                color:          "black"
                visible:        true
            }

            Rectangle {
                anchors.left:   parent.left
                anchors.bottom: parent.bottom
                width:          _frameSize
                height:         _frameSize
                color:          "black"
                visible:        true
            }

            Rectangle {
                anchors.right:  parent.right
                anchors.bottom: parent.bottom
                width:          _frameSize
                height:         _frameSize
                color:          "black"
                visible:        true
            }

            Rectangle {
                anchors.margins:    _root.padding
                anchors.fill:       parent
                color:              "gray"
            }
        }
        Component.onCompleted: {
            _dialogTitle = "dialogComponentLoader.item.title"
            setupDialogButtons(StandardButton.Ok)
        }
        function setupDialogButtons(buttons) {
                acceptButton.visible = false
                rejectButton.visible = false
                // Accept role buttons
                if (buttons & StandardButton.Ok) {
                    acceptButton.text = qsTr("Ok")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Open) {
                    acceptButton.text = qsTr("Open")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Save) {
                    acceptButton.text = qsTr("Save")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Apply) {
                    acceptButton.text = qsTr("Apply")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Open) {
                    acceptButton.text = qsTr("Open")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.SaveAll) {
                    acceptButton.text = qsTr("Save All")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Yes) {
                    acceptButton.text = qsTr("Yes")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.YesToAll) {
                    acceptButton.text = qsTr("Yes to All")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Retry) {
                    acceptButton.text = qsTr("Retry")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Reset) {
                    acceptButton.text = qsTr("Reset")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.RestoreToDefaults) {
                    acceptButton.text = qsTr("Restore to Defaults")
                    acceptButton.visible = true
                } else if (buttons & StandardButton.Ignore) {
                    acceptButton.text = qsTr("Ignore")
                    acceptButton.visible = true
                }

                // Reject role buttons
                if (buttons & StandardButton.Cancel) {
                    rejectButton.text = qsTr("Cancel")
                    rejectButton.visible = true
                } else if (buttons & StandardButton.Close) {
                    rejectButton.text = qsTr("Close")
                    rejectButton.visible = true
                } else if (buttons & StandardButton.No) {
                    rejectButton.text = qsTr("No")
                    rejectButton.visible = true
                } else if (buttons & StandardButton.NoToAll) {
                    rejectButton.text = qsTr("No to All")
                    rejectButton.visible = true
                } else if (buttons & StandardButton.Abort) {
                    rejectButton.text = qsTr("Abort")
                    rejectButton.visible = true
                }

                if (rejectButton.visible) {
                    closePolicy = Popup.NoAutoClose | Popup.CloseOnEscape
                } else {
                    closePolicy = Popup.NoAutoClose
                }
            }
        ColumnLayout {
                id:         mainColumnLayout
                spacing:    _contentMargin

                RowLayout {
                    id:                 titleRowLayout
                    Layout.fillWidth:   true

                    Label {
                        Layout.leftMargin:  ScreenTools.defaultFontPixelWidth
                        Layout.fillWidth:   true
                        text:               _dialogTitle
                        font.pointSize:     5//ScreenTools.mediumFontPointSize
                        verticalAlignment:	Text.AlignVCenter
                    }

                    Button {
                        id:         rejectButton
//                        onClicked:  dialogComponentLoader.item.reject()
                    }

                    Button {
                        id:         acceptButton
//                        primary:    true
//                        onClicked:  dialogComponentLoader.item.accept()
                    }
                }

                Flickable {
                    id:                     mainFlickable
                    Layout.preferredWidth:  Math.min(marginItem.width, _maxContentWidth)
                    Layout.preferredHeight: Math.min(marginItem.height, _maxContentHeight)
                    contentWidth:           marginItem.width
                    contentHeight:          marginItem.height

                    Item {
                        id:     marginItem
                        width:  400//columnHolder.width + (_contentMargin * 2)
                        height: 400//columnHolder.height + _contentMargin
                            ColumnLayout {
                                id:columnHolder
                                anchors.fill: parent
                                spacing:_margin
                                GridLayout {
                                    Layout.fillWidth: true
                                    visible: true
                                    columns: 2
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
                }
            }

    }




}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1}
}
##^##*/

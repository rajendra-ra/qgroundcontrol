/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0

//-------------------------------------------------------------------------
//-- Message Indicator
Item {
    id:             _root
    width:          height*5
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: true

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property bool   _isMessageImportant:    _activeVehicle ? !_activeVehicle.messageTypeNormal && !_activeVehicle.messageTypeNone : false
    property real vibeX: _activeVehicle ?_activeVehicle.vibration.xAxis.value.toFixed(2):0
    property real vibeY: _activeVehicle ?_activeVehicle.vibration.yAxis.value.toFixed(2):0
    property real vibeZ: _activeVehicle ?_activeVehicle.vibration.zAxis.value.toFixed(2):0
    property real vibeThreshold: _activeVehicle ?_activeVehicle.vibration.vibeThreshold.value.toFixed(2):0

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 6
        Rectangle {
            color: 'transparent'
            Layout.fillWidth: true
            Layout.fillHeight: true
            QGCColoredImage {
                anchors.fill:       parent
                source:             "/qmlimages/Soundwave.svg"
                sourceSize.height:  height
                fillMode:           Image.PreserveAspectFit
                color:              getMessageColor()
                visible:            true
            }
            MouseArea {
                anchors.fill:   parent
                onClicked:      mainWindow.showIndicatorPopup(_root, rcRSSIInfo)
            }
        }
        Rectangle {
            color: 'transparent'
            Layout.fillWidth: true
            Layout.fillHeight: true
            Column {
                visible: Math.max(vibeX,vibeY,vibeZ) > vibeThreshold
                Text {
                    id:             highVibeLabel
                    text:           qsTr("High Vibration")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "red"
                }
                GridLayout {
                    id:                 highVibeGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            3
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: xWarnText
                        text: qsTr("X-Axis")
                        color: "red"
                        visible: vibeX > vibeThreshold
                    }
                    Text {
                        id: yWarnText
                        text: qsTr("Y-Axis")
                        color: "red"
                        visible: vibeY > vibeThreshold
                    }
                    Text {
                        id: zWarnText
                        text: qsTr("Z-Axis")
                        color: "red"
                        visible: vibeZ > vibeThreshold
                    }
                }
            }
        }
    }
    Component {
        id: rcRSSIInfo

        Rectangle {
            width:  rcrssiCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: rcrssiCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 rcrssiCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(rcrssiGrid.width, rssiLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             rssiLabel
                    text:           _activeVehicle ? qsTr("Vibration") : qsTr("Data Unavailable")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 rcrssiGrid
                    visible:            true
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    rows: 4
                    anchors.horizontalCenter: parent.horizontalCenter

                    QGCLabel { text: qsTr("X-Axis:") }
                    QGCLabel { text: vibeX }
                    QGCLabel { text: qsTr("Y-Axis:") }
                    QGCLabel { text: vibeY }
                    QGCLabel { text: qsTr("Z-Axis:") }
                    QGCLabel { text: vibeZ }
                    TextField {
                        id: vibeThresholdField
                        focus: true
                        maximumLength: 7
                        placeholderText: "Vibration Threshold"
                        text: vibeThreshold
                        onEditingFinished: {
                            vibeThreshold = parseFloat(vibeThresholdField.text)
                        }
                    }

                    Rectangle {
                        color: "white"
                        Layout.column: 1
                        Layout.row: 3
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            text: "Set"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
//                                console.log(vibeThresholdField.text);
//                                console.log(vibeThreshold);
                            }
                        }
                    }
                }
            }
        }
    }
    Component {
        id: vehicleMessagesPopup

        Rectangle {
            width:          mainWindow.width  * 0.666
            height:         mainWindow.height * 0.666
            radius:         ScreenTools.defaultFontPixelHeight / 2
            color:          qgcPal.window
            border.color:   qgcPal.text

            function formatMessage(message) {
                message = message.replace(new RegExp("<#E>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                message = message.replace(new RegExp("<#I>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                message = message.replace(new RegExp("<#N>", "g"), "color: " + qgcPal.text + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                return message;
            }

            Component.onCompleted: {
                messageText.text = formatMessage(_activeVehicle.formattedMessages)
                //-- Hack to scroll to last message
                for (var i = 0; i < _activeVehicle.messageCount; i++)
                    messageFlick.flick(0,-5000)
                _activeVehicle.resetMessages()
            }

            Connections {
                target: _activeVehicle
                onNewFormattedMessage :{
                    messageText.append(formatMessage(formattedMessage))
                    //-- Hack to scroll down
                    messageFlick.flick(0,-500)
                }
            }

            QGCLabel {
                anchors.centerIn:   parent
                text:               qsTr("No Messages")
                visible:            messageText.length === 0
            }

            //-- Clear Messages
            QGCColoredImage {
                anchors.bottom:     parent.bottom
                anchors.right:      parent.right
                anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.5
                height:             ScreenTools.isMobile ? ScreenTools.defaultFontPixelHeight * 1.5 : ScreenTools.defaultFontPixelHeight
                width:              height
                sourceSize.height:   height
                source:             "/res/TrashDelete.svg"
                fillMode:           Image.PreserveAspectFit
                mipmap:             true
                smooth:             true
                color:              qgcPal.text
                visible:            messageText.length !== 0
                MouseArea {
                    anchors.fill:   parent
                    onClicked: {
                        if (_activeVehicle) {
                            _activeVehicle.clearMessages()
                            mainWindow.hideIndicatorPopup()
                        }
                    }
                }
            }

            QGCFlickable {
                id:                 messageFlick
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.fill:       parent
                contentHeight:      messageText.height
                contentWidth:       messageText.width
                pixelAligned:       true

                TextEdit {
                    id:             messageText
                    readOnly:       true
                    textFormat:     TextEdit.RichText
                    color:          qgcPal.text
                }
            }
        }
    }
}

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
        spacing: ScreenTools.defaultFontPixelWidth
        Rectangle {
            color: 'transparent'
            implicitWidth: height
            Layout.fillHeight: true
            QGCColoredImage {
                anchors.fill:       parent
                source:             "/qmlimages/Soundwave.svg"
                sourceSize.height:  height
                fillMode:           Image.PreserveAspectFit
                visible:            true
            }
            MouseArea {
                anchors.fill:   parent
                onClicked:      mainWindow.showIndicatorPopup(_root, vibeInfo)
            }
        }
        Rectangle {
            color: 'transparent'
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: "grey"
            border.width: 1
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
                    id:                 highvibeGrid
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
        id: vibeInfo

        Rectangle {
            width:  vibeCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: vibeCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 vibeCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(vibeGrid.width, vibeLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             vibeLabel
                    text:           _activeVehicle ? qsTr("Vibration (m/s/s)") : qsTr("Data Unavailable")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 vibeGrid
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
                            onClicked: {  }
                        }
                    }
                }
            }
        }
    }
}

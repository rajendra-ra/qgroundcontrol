/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.12
import QtQuick.Layouts  1.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.2
import QtQuick.Extras   1.4

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.Palette       1.0

ColumnLayout {
    id:         root
    spacing:    ScreenTools.defaultFontPixelHeight / 4

    property real   _innerRadius:           (width - (_topBottomMargin * 3)) / 4
    property real   _outerRadius:           _innerRadius + _topBottomMargin
    property real   _spacing:               ScreenTools.defaultFontPixelHeight * 0.33
    property real   _topBottomMargin:       (width * 0.05) / 2
    property var    vehicle: globals.activeVehicle
    property bool name_s: false

    function nameChanged(){
        name_s = !name_s;
    }

    QGCPalette { id: qgcPal }
    Rectangle {
        height:             _outerRadius * 1.5
        Layout.fillWidth:   true
        color: "transparent"
        MouseArea {
            anchors.fill: parent
            onClicked: {
//                parent.color = "red";
                mainWindow.showPopupDialogFromComponent(nameChangeDialog, { });
            }
        }
        GridLayout {
            id:                 routerStatus
            columns: 2
            rows: 4
            columnSpacing: 0
            rowSpacing: 0
            anchors.fill: parent
            flow: GridLayout.TopToBottom
            Repeater {
                id: indicatorRepeater
                model: vehicle?vehicle.routerChannelNum.rawValue:0
                Rectangle {
//                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    height: ScreenTools.defaultFontPixelHeight
                    border.width: 0
                    radius: ScreenTools.defaultFontPixelHeight
                    color: qgcPal.window
                    Rectangle {
                        id: indicator
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: height
                        radius: height
                        color: checkIfActive(index)?"green":"red"
                        function checkIfActive(i){
                            var x = vehicle?vehicle.routerStatus.rawValue:0;
    //                        console.log((1<<i)&x,vehicle.routerChannelNum.rawValue);
                            return (1<<i)&x;
                        }
                    }

                    Text {
                        property bool name: name_s
                        anchors.left: indicator.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignHCenter
                        text: vehicle.getRouterChannelName(index)
                        color: "white"
                        onNameChanged: text=vehicle.getRouterChannelName(index)
                    }
                }
            }
        }
    }


    Rectangle {
        id:                 visualInstrument
        height:             _outerRadius * 2
        Layout.fillWidth:   true
        radius:             _outerRadius
        color:              qgcPal.window

        DeadMouseArea { anchors.fill: parent }

        QGCAttitudeWidget {
            id:                     attitude
            anchors.leftMargin:     _topBottomMargin
            anchors.left:           parent.left
            size:                   _innerRadius * 2
            vehicle:                globals.activeVehicle
            anchors.verticalCenter: parent.verticalCenter
        }

        QGCCompassWidget {
            id:                     compass
            anchors.leftMargin:     _spacing
            anchors.left:           attitude.right
            size:                   _innerRadius * 2
            vehicle:                globals.activeVehicle
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    TerrainProgress {
        Layout.fillWidth: true
    }
    Component {
        id: nameChangeDialog

        QGCPopupDialog {
//            id: nameChangeDialog
            title:      qsTr("Channel Name(s)")
            buttons:    StandardButton.Close

            ColumnLayout {
                Repeater {
                    model: vehicle?vehicle.routerChannelNum.rawValue:0

                    Row {
                        height: ScreenTools.minTouchPixels
                        Layout.fillWidth: true

                        QGCLabel {
                            width:      80
                            text:       qsTr("CH "+index)
                            wrapMode:   Text.WordWrap
                        }
                        QGCTextField {
                            text:               vehicle.getRouterChannelName(index)
                            onEditingFinished:  updateChannelName(index, text)
                            function updateChannelName(index,text){
                                vehicle.setRouterChannelName(index,text);
                            }
                        }
                    }
                }
            }
            onHideDialog: nameChanged()
        }
    }
}

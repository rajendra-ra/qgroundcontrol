/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Layouts  1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
Item {
    id: _root

    property bool showIndicator: networkIndicatorEnabled & 255

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property real networkIndicatorEnabled: _activeVehicle ?_activeVehicle.networkIndicatorEnabled.value:0
    property real networkStatus: _activeVehicle ?_activeVehicle.networkStatus.value:0

    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    width: height*2 + ScreenTools.defaultFontPixelWidth

    Row {
        anchors.fill: parent
        spacing: ScreenTools.defaultFontPixelWidth
        Rectangle {
            width:height
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top
            color: "transparent"
            QGCColoredImage {
                id:                 dlbIcon
                width:              height
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                source:             "/qmlimages/DLB.svg"
                fillMode:           Image.PreserveAspectFit
                sourceSize.height:  height
                opacity:            1//_activeVehicle && (networkStatus & 0b1) ? 0.4 : 0.5
                color:              _activeVehicle && (networkStatus & 0b1) ? "green" : "red"
            }
        }
        Rectangle {
            width:height
            height: parent.height
            anchors.right: parent.right
            anchors.top: parent.top
            color: "transparent"
            QGCColoredImage {
                id:                 obcIcon
                width:              height
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                source:             "/qmlimages/OBC.svg"
                fillMode:           Image.PreserveAspectFit
                sourceSize.height:  height
                opacity:            1//_activeVehicle && (networkStatus & 0b1) ? 0.4 : 0.4
                color:              _activeVehicle && (networkStatus & 0b10) ? "green" : "red"
            }
        }
    }
    //-- OBC Indicator
    /*Rectangle {
        id:             _rootOBC
        width:          (obcValuesColumn.x + obcValuesColumn.width) * 1.1
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        color: "blue"

        /*Component {
            id: gpsInfo

            Rectangle {
                width:  gpsCol.width   + ScreenTools.defaultFontPixelWidth  * 3
                height: gpsCol.height  + ScreenTools.defaultFontPixelHeight * 2
                radius: ScreenTools.defaultFontPixelHeight * 0.5
                color:  qgcPal.window
                border.color:   qgcPal.text

                Column {
                    id:                 gpsCol
                    spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                    width:              Math.max(gpsGrid.width, gpsLabel.width)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    anchors.centerIn:   parent

                    QGCLabel {
                        id:             gpsLabel
                        text:           (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? qsTr("GPS Status") : qsTr("GPS Data Unavailable")
                        font.family:    ScreenTools.demiboldFontFamily
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    GridLayout {
                        id:                 gpsGrid
                        visible:            (_activeVehicle && _activeVehicle.gps.count.value >= 0)
                        anchors.margins:    ScreenTools.defaultFontPixelHeight
                        columnSpacing:      ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        columns: 2

                        QGCLabel { text: qsTr("GPS Count:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.count.valueString : qsTr("N/A", "No data to display") }
                        QGCLabel { text: qsTr("GPS Lock:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.lock.enumStringValue : qsTr("N/A", "No data to display") }
                        QGCLabel { text: qsTr("HDOP:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.hdop.valueString : qsTr("--.--", "No data to display") }
                        QGCLabel { text: qsTr("VDOP:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.vdop.valueString : qsTr("--.--", "No data to display") }
                        QGCLabel { text: qsTr("Course Over Ground:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.courseOverGround.valueString : qsTr("--.--", "No data to display") }
                    }
                }
            }
        }*/

        /*QGCColoredImage {
            id:                 obcIcon
            width:              height
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             "/qmlimages/Gps.svg"
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            opacity:            (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? 1 : 0.5
            color:              "yellow"//qgcPal.buttonText
        }

        Column {
            id:                     obcValuesColumn
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:     ScreenTools.defaultFontPixelWidth / 2
            anchors.left:           obcIcon.right

            QGCLabel {
                anchors.horizontalCenter:   obcValue.horizontalCenter
                visible:                    _activeVehicle && !isNaN(_activeVehicle.gps.hdop.value)
                color:                      qgcPal.buttonText
                text:                       _activeVehicle ? _activeVehicle.gps.count.valueString : ""
            }

            QGCLabel {
                id:         obcValue
                visible:    _activeVehicle && !isNaN(_activeVehicle.gps.hdop.value)
                color:      qgcPal.buttonText
                text:       _activeVehicle ? _activeVehicle.gps.hdop.value.toFixed(1) : ""
            }
        }*/

        /*MouseArea {
            anchors.fill:   parent
            onClicked: {
                mainWindow.showIndicatorPopup(_rootOBC, obcInfo)
            }
        }*/
//    }
//-- DLB Indicator
    /*Rectangle {
        id:             _rootDLB
        width:          (dlbValuesColumn.x + dlbValuesColumn.width) * 1.1
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        color: "red"



        /*Component {
            id: gpsInfo

            Rectangle {
                width:  gpsCol.width   + ScreenTools.defaultFontPixelWidth  * 3
                height: gpsCol.height  + ScreenTools.defaultFontPixelHeight * 2
                radius: ScreenTools.defaultFontPixelHeight * 0.5
                color:  qgcPal.window
                border.color:   qgcPal.text

                Column {
                    id:                 gpsCol
                    spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                    width:              Math.max(gpsGrid.width, gpsLabel.width)
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    anchors.centerIn:   parent

                    QGCLabel {
                        id:             gpsLabel
                        text:           (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? qsTr("GPS Status") : qsTr("GPS Data Unavailable")
                        font.family:    ScreenTools.demiboldFontFamily
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    GridLayout {
                        id:                 gpsGrid
                        visible:            (_activeVehicle && _activeVehicle.gps.count.value >= 0)
                        anchors.margins:    ScreenTools.defaultFontPixelHeight
                        columnSpacing:      ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        columns: 2

                        QGCLabel { text: qsTr("GPS Count:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.count.valueString : qsTr("N/A", "No data to display") }
                        QGCLabel { text: qsTr("GPS Lock:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.lock.enumStringValue : qsTr("N/A", "No data to display") }
                        QGCLabel { text: qsTr("HDOP:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.hdop.valueString : qsTr("--.--", "No data to display") }
                        QGCLabel { text: qsTr("VDOP:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.vdop.valueString : qsTr("--.--", "No data to display") }
                        QGCLabel { text: qsTr("Course Over Ground:") }
                        QGCLabel { text: _activeVehicle ? _activeVehicle.gps.courseOverGround.valueString : qsTr("--.--", "No data to display") }
                    }
                }
            }
        }*/

        /*QGCColoredImage {
            id:                 dlbIcon
            width:              height
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             "/qmlimages/Gps.svg"
            fillMode:           Image.PreserveAspectFit
            sourceSize.height:  height
            opacity:            (_activeVehicle && _activeVehicle.gps.count.value >= 0) ? 1 : 0.5
            color:              qgcPal.buttonText
        }

        Column {
            id:                     dlbValuesColumn
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:     ScreenTools.defaultFontPixelWidth / 2
            anchors.left:           gpsIcon.right

            QGCLabel {
                anchors.horizontalCenter:   dlbValue.horizontalCenter
                visible:                    _activeVehicle && !isNaN(_activeVehicle.gps.hdop.value)
                color:                      qgcPal.buttonText
                text:                       _activeVehicle ? _activeVehicle.gps.count.valueString : ""
            }

            QGCLabel {
                id:         dlbValue
                visible:    _activeVehicle && !isNaN(_activeVehicle.gps.hdop.value)
                color:      qgcPal.buttonText
                text:       _activeVehicle ? _activeVehicle.gps.hdop.value.toFixed(1) : ""
            }
        }*/

        /*MouseArea {
            anchors.fill:   parent
            onClicked: {
                mainWindow.showIndicatorPopup(_rootDLB, dlbInfo)
            }
        }*/
//    }*/
//    }
}

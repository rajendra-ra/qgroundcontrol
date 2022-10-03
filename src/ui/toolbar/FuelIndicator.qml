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
import MAVLink                              1.0

//-------------------------------------------------------------------------
//-- Fuel Indicator
Item {
    id:             _root
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    width:          fuelIndicatorRow.width

    property bool showIndicator: true

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    Grid {
        id:             fuelIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        columns: 1
        rows: 2
        spacing: 2

        Text {
            id: _fuelLabel
            color: "white"
            text: qsTr("Fuel Level")
        }
        Text {
            id: _fuelVal
            color: "green"
            text: _activeVehicle?_activeVehicle.fuelLevel:"NA"
        }
    }
}

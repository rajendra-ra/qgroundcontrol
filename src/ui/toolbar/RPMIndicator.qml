/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
/**
 * RPM Indicator UI File to display Engine RPM and Rotor RPM.  
 */
import QtQuick                              2.11
import QtQuick.Controls                     2.4

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.Vehicle               1.0

Item {
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    width:          rpmIndicatorRow.width

    property bool showIndicator: true

    property var _activeVehicle:    QGroundControl.multiVehicleManager.activeVehicle

    Grid {
        id:             rpmIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        columns: 2
        rows: 2
        spacing: 2
        columnSpacing: 5

        Text {
            id: _engineLabel
            color: "white"
            text: qsTr("Engine RPM")
        }
        Text {
            id: _rotorLabel
            color: "white"
            text: qsTr("Rotor RPM")
        }
        Text {
            id: _engineVal
            color: "red"
            text: _activeVehicle?_activeVehicle.engineRPM.rawValue.toFixed(2):"NA"
        }
        Text {
            id: _rotorVal
            color: "red"
            text: _activeVehicle?_activeVehicle.rotorRPM.rawValue.toFixed(2):"NA"
        }
    }
}

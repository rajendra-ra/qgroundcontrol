import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQuick.Dialogs              1.3
import QtQuick.Layouts              1.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0

/// Joystick Config
SetupPage {
    id:                 signingPage
    pageComponent:      pageComponent
    pageName:           qsTr("Mavlink Signing")
    pageDescription:    "" // qsTr("Joystick Setup is used to configure and calibrate joysticks.")

    Component {
        id: pageComponent
        Column {
            width:   availableWidth
            height:  availableHeight
            spacing: ScreenTools.defaultFontPixelHeight
            QGCTextField {
                id: secretKeyInput
                text:           "admin123"
                Layout.alignment: Qt.AlignTop
                visible:        true//feature ? (feature.type !== AirspaceRuleFeature.Boolean) : false
                showUnits:      false
                height: setupSigningButton.height
                unitsLabel: {
                    return ""
                }
//                    anchors.right:  parent.right
//                    anchors.left:   setupSigningButton.right
                inputMethodHints: Qt.ImhNone;//feature ? (feature.type === AirspaceRuleFeature.Float ? Qt.ImhFormattedNumbersOnly : Qt.ImhNone) : Qt.ImhNone
//                    onAccepted: {
//                        if(feature)
//                            feature.value = text;//parseFloat(text)
//                    }
//                    onEditingFinished: {
//                        if(feature)
//                            feature.value = text;//parseFloat(text)
//                    }
            }
            Row {
                Layout.alignment: Qt.AlignTop
                QGCButton {
                    id:         enableSigningButton
                    text:       qsTr("Enable Signing")
                    width: setupSigningButton.width
                    visible:    !globals.activeVehicle.armed
                    onClicked:  {
                        console.log('EnableSigning KEY: ',secretKeyInput.text);
                        globals.activeVehicle.enableSigning(secretKeyInput.text)
                    }
                }
                QGCButton {
                    id:         setupSigningButton
                    text:       qsTr("Setup Signing")
                    visible:    !globals.activeVehicle.armed
                    onClicked:  {
                        console.log('SetupSigning KEY: ',secretKeyInput.text);
                        globals.activeVehicle.setupSigning(secretKeyInput.text)
                    }
                }
                QGCButton {
                    id:         resetSigningButton
                    text:       qsTr("Reset Signing")
                    visible:    !globals.activeVehicle.armed
                    onClicked:  {
                        console.log('ResetSigning');
                        globals.activeVehicle.resetSigning()
                    }
                }
            }

        }
    }
}




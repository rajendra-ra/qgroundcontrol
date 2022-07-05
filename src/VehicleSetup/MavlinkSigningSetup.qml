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
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.documents
        nameFilters: [ "Key file (*.key)" ]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
//            Qt.quit()
            globals.activeVehicle.chooseFile(fileDialog.fileUrl);
//            fileLabel.text = fileDialog.fileUrl;
        }
        onRejected: {
            console.log("Canceled")
//            Qt.quit()
        }
//        Component.onCompleted: visible = true
    }
    Component {
        id: pageComponent
        Column {
            width:   availableWidth
            height:  availableHeight
            spacing: ScreenTools.defaultFontPixelHeight
            Row {
                QGCButton {
                    id: secretKeyInput
                    text:           qsTr("Choose key file")
                    Layout.alignment: Qt.AlignTop
                    visible:        true//feature ? (feature.type !== AirspaceRuleFeature.Boolean) : false
                    height: setupSigningButton.height
                    onClicked:  {
                        console.log('choose file');
                        fileDialog.open();
                    }
                }
                Label {
                    id: fileLabel
                    text: globals.activeVehicle.keyFile
                    height: setupSigningButton.height
                    color: "white"
                    font.family: "Helvetica"
                    padding: 5
                    font.pixelSize: ScreenTools.defaultFontPixelHeight
                }
            }

            Row {
                spacing: 1
                QGCButton {
                    id:         enableSigningButton
                    text:       qsTr("Enable Signing")
                    width: setupSigningButton.width
                    visible:    !globals.activeVehicle.armed
                    onClicked:  {
//                        console.log('EnableSigning KEY: ',secretKeyInput.text);
                        globals.activeVehicle.enableSigning();
                    }
                }
                QGCButton {
                    id:         setupSigningButton
                    text:       qsTr("Setup Signing")
                    visible:    !globals.activeVehicle.armed
                    onClicked:  {
//                        console.log('SetupSigning KEY: ',secretKeyInput.text);
                        globals.activeVehicle.setupSigning();
                    }
                }
                QGCButton {
                    id:         resetSigningButton
                    text:       qsTr("Reset Signing")
                    visible:    !globals.activeVehicle.armed
                    onClicked:  {
//                        console.log('ResetSigning');
                        globals.activeVehicle.resetSigning();
                    }
                }
            }

        }
    }
}




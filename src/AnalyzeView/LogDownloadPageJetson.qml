/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.2
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0

AnalyzePage {
    id:                 logDownloadPageJetson
    pageComponent:      pageComponent
    pageDescription:    qsTr("Log Download Jetson allows you to download binary log / video logs / ROS logs files from your vehicle. Click Refresh to get list of available logs.")

    property real _margin:          ScreenTools.defaultFontPixelWidth
    property real _butttonWidth:    ScreenTools.defaultFontPixelWidth * 10
    property bool _isBusy: fileDownloader.isBusy
    property real _progress: 0.0

    QGCPalette { id: palette; colorGroupEnabled: enabled }


    Component {
        id: pageComponent

        ColumnLayout {
            width:  availableWidth
            height:  availableHeight
            Connections {
                target: fileDownloader
                onIndexingSuccessful:{
                    console.log("indexing Successful");
                    listView1.resizeColumnsToContents();
//                    console.log(fileDownloader.indexList)
//                    listView1.model = fileDownloader.indexList;
                }
                onGoingBusy:{
                    console.log("Downloading in Progress");

                }
                onBackReady:{
                    console.log("Downloading Successful");
                }
                onDownloadProgress:{
                    if(bytesTotal){
                        _progress = bytesReceived/bytesTotal;
                    } else {
                        _progress = 0.0
                    }
                }
            }
            RowLayout {
//                width:  availableWidth
//                height: availableHeight
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight*1.5
                Layout.alignment: Qt.AlignTop
                id:addressRow

                TextField {
                    id:addressField
                    property string rootUri: "http://localhost:8000/"
                    text: "http://localhost:8000/"
                    placeholderText: "http://localhost:8000/"
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    font.pointSize: 14
                    onAccepted: {fileDownloader.startDownloadIndex(text);}
                }
                Button {
                    id: upFolder
                    text: qsTr("Back")
                    Layout.preferredHeight: addressField.height
                    width:height
                    style: ButtonStyle {
                        label: Text {
                            renderType: Text.NativeRendering
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "Helvetica"
                            font.pointSize: 14
                            color: "white"
                            text: upFolder.text
                        }
                        background: Rectangle {
                            color: palette.windowShade
                        }
                    }
                    onClicked: {
                        let addr = addressField.text.trim()
                        let a = addr.split("/")
                        removeLast(a)
                        addr = a.join("/")+"/"
                        addressField.text = addr
                        fileDownloader.startDownloadIndex(addr?addr:addressField.text);
                    }
                    function removeLast(a){
                        let last = a.pop()
                        if(last===""){
                            removeLast(a)
                        }
                        if(a.length<3){
                            a.push(last)
                            return;
                        }

                    }
                }

                Label {
                    id:progressLabel
                    Layout.preferredHeight: addressField.height
                    verticalAlignment: Qt.AlignVCenter
                    text: _isBusy?"Busy":"Ready"
                    color: _isBusy?"red":"green"
                    font.pointSize: 14
                }
                ProgressBar {
                    Layout.preferredHeight: addressField.height
                    id:downloadProgress
                    value: _progress
                }
            }
            RowLayout {
                id:indexListLayout
//                width:  availableWidth
//                height: availableHeight
                Layout.fillWidth: true
                Layout.fillHeight: true
                TableView {
                    id: listView1
                    Layout.fillWidth: true
                    Layout.fillHeight:  true
                    model: fileDownloader.indexList
                    TableViewColumn {
                        title: qsTr("File")
                        width: ScreenTools.defaultFontPixelWidth * 6
                        horizontalAlignment: Text.AlignLeft
                        delegate : Text  {
                            horizontalAlignment: Text.AlignLeft
                            font.pointSize: 13
                            text: {
                                var o = modelData
                                return o ? o : ""
                            }
                        }
                    }
                    onDoubleClicked: {
                       let s = listView1.model[row]
                        if(s.endsWith("/")){
                            if(addressField.text.endsWith("/")){
                                addressField.text = addressField.text+ s;
                            } else {
                                addressField.text = addressField.text+"/" + s;
                            }


                            fileDownloader.startDownloadIndex(addressField.text);
                        }

                        console.log("DoubleClicked:",row,listView1.model[row])
                    }
                }
                Column {
                    spacing:            _margin
                    Layout.alignment:   Qt.AlignTop | Qt.AlignLeft
                    QGCButton {
                        id: refreshBtn
                        enabled:    !fileDownloader.isBusy//!logController.requestingList && !logController.downloadingLogs
                        text:       qsTr("Refresh")
                        width:      _butttonWidth
                        font.pointSize: 14
                        onClicked: {
//                            if (!QGroundControl.multiVehicleManager.activeVehicle || QGroundControl.multiVehicleManager.activeVehicle.isOfflineEditingVehicle) {
//                                mainWindow.showMessageDialog(qsTr("Log Refresh"), qsTr("You must be connected to a vehicle in order to download logs."))
//                            } else {
//                                logController.refresh()
//                            }
//                            addressField.rootUri = addressField.text
                            fileDownloader.startDownloadIndex(addressField.text);
                        }
                    }
                    QGCButton {
                        id: downloadBtn
                        enabled:   /* !logController.requestingList && !logController.downloadingLogs && */listView1.selection.count > 0 && !fileDownloader.isBusy
                        text:       qsTr("Download")
                        width:      _butttonWidth
                        font.pointSize: 14
                        onClicked: {
                            //-- Clear selection
//                            for(var i = 0; i < logController.model.count; i++) {
//                                var o = logController.model.get(i)
//                                if (o) o.selected = false
//                            }
                            //-- Flag selected log files
                            listView1.selection.forEach(function(rowIndex){
                                let s = listView1.model[rowIndex]
                                let x = ""
                                if(!s.endsWith("/") && !fileDownloader.isBusy){
                                    if(addressField.text.endsWith("/")){
                                        x= addressField.text+ s;
                                    } else {
                                        x = addressField.text+"/" + s;
                                    }
                                    fileDownloader.startDownload(x,QGroundControl.settingsManager.appSettings.logSavePath+"/"+s);
                                }
                                console.log("selected index:",rowIndex);
//                                var o = logController.model.get(rowIndex)
//                                if (o) o.selected = true
                            })
//                            if (ScreenTools.isMobile) {
//                                // You can't pick folders in mobile, only default location is used
////                                logController.download()
//                            } else {
//                                fileDialog.title =          qsTr("Select save directory")
//                                fileDialog.selectExisting = true
//                                fileDialog.folder =         QGroundControl.settingsManager.appSettings.logSavePath
//                                fileDialog.selectFolder =   true
//                                fileDialog.openForLoad()
//                            }
                        }
                        QGCFileDialog {
                            id: fileDialog
                            onAcceptedForLoad: {
                                console.log("saved file:",file);
//                                fileDownloader.startDownload(,file+listView1.selection.get())
                                close()
                            }
                        }
                    }
                }
            }
        }
    }
}

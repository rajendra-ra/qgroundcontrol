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
import QtQml.Models             2.15

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
    property bool _isBusy: fileDownloader.isBusy || (_downloadListFiles.length>0)
    property real _progress: 0.0
    property bool _dirdownload: false
    property var _root:null
    property var  _indexModel: fileDownloader.indexList
//    property var _currentIndexList: fileDownloader.indexList
    property var _downloadListDir: []
    property var _downloadListFiles :[]
    property int _totalFiles:0
//    signal requestList(var url);
//    onRequestList: {
//        fileDownloader.startDownloadIndex(url)
//    }

    QGCPalette { id: palette; colorGroupEnabled: enabled }
//    ListModel {
//        id:_indexModel
//    }

    Component {
        id: pageComponent

        ColumnLayout {
            width:  availableWidth
            height:  availableHeight
            Connections {
                target: fileDownloader
                onIndexingSuccessful:{
//                    console.log("indexing Successful");
                    listView1.resizeColumnsToContents();
//                    listView1.resizeRowsToContents();
                    addressField.text = _url;
                    if(_dirdownload){
//                        console.log("dirdownload list",_dirdownload);
                        for(let i=0;i<_indexModel.count;i++){
                            let x = _indexModel.get(i)
                            let _path = _root.dir + x.url.split(_root.dir)[1]
                            let y = {url:x.url,path:_path}

//                            console.log("item ",x.url);
                            if(x.isDir){
                                _downloadListDir.push(y);
                            } else {
                                _downloadListFiles.push(y);
                            }

//                            _downloadList.push(x.url);
//                            console.log("indexModel:",_indexModel.count)
                        }
//                        _downloadList = fileDownloader.indexList
//                        listView1.model = _indexModel;
                    } else {
                        _downloadListDir = []
                        _downloadListFiles = []
//                        for(let j=0;j<_currentIndexList.count;j++){
//                            let x = _currentIndexList.get(j)
//                            console.log("item ",x);
//                            _indexModel.append(x);
//                            console.log("indexModel:",_indexModel.count)
//                        }
                    }

                }
                onGoingBusy:{
//                    console.log("Downloading in Progress");

                }
                onBackReady:{
                    if(_dirdownload){
//                        console.log("recursively request:",_downloadListDir.length);
                        if(_downloadListDir.length>0){
//                            console.log("remaining dirs:",_downloadListDir.length);
                        } else if(_downloadListFiles.length>0){
//                            console.log("remaining files:",_downloadListFiles.length)
                        } else {
//                            console.log("Downloaded All files Successful");
                            _totalFiles = 0;
                        }
                    } else {
//                        console.log("Downloading Successful");
                        _progress = 0.0
                    }
                }
                onIsBusyChanged:{
                    if(!isBusy && _dirdownload){
                        if(_downloadListDir.length>0){
                            let _item = _downloadListDir.pop();
//                            console.log("request dir:",_item.url,fileDownloader.isBusy);
                            fileDownloader.startDownloadIndex(_item.url);
                        } else {
                            if(_downloadListFiles.length >0){
                                if(_totalFiles==0){
                                    _totalFiles = _downloadListFiles.length
                                }
                                let _item = _downloadListFiles.pop();
//                                console.log("request file:",_item.url,_item.path);
                                fileDownloader.startDownload(_item.url,QGroundControl.settingsManager.appSettings.logSavePath+"/"+decodeURIComponent(_item.path));
//                                fileDownloader.startDownload(_text,)
                            } else {
                                _dirdownload = false
//                                console.log("go back to root path");
                                fileDownloader.startDownloadIndex(_root.path);
                            }
                        }


                    }
                }

                onDownloadProgress:{
                    if(bytesTotal){
                        _progress = bytesReceived/bytesTotal;
                        if(_dirdownload && _totalFiles){
                            _progress = 1-_downloadListFiles.length/_totalFiles;
                        }
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
                    model: _indexModel/*fileDownloader.indexList*/
                    Component.onCompleted: {/*_indexModel = fileDownloader.indexList;*/}
                    TableViewColumn {
                        title: qsTr("File")
                        width: ScreenTools.defaultFontPixelWidth * 6
                        horizontalAlignment: Text.AlignLeft
                        delegate : Text  {
                            horizontalAlignment: Text.AlignLeft
                            font.pointSize: 13
                            text: {
//                                console.log("tableview:",index);
//                                return "test";
                                var o = modelData;
                                return o ? o : ""
                            }
                        }
                    }
                    onDoubleClicked: {
                       let s = listView1.model.get(row)
//                        let s = modelData
                        if(s.isDir){
                            let x = ""
                            if(addressField.text.endsWith("/")){
                                x = addressField.text+ s.fullname;
                            } else {
                                x = addressField.text+"/" + s.fullname;
                            }


                            fileDownloader.startDownloadIndex(x);
                        }

//                        console.log("DoubleClicked:",row,s.fullname)
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
                                let s = listView1.model.get(rowIndex)
                                let x = ""
                                if(!s.isDir && !fileDownloader.isBusy){
                                    if(addressField.text.endsWith("/")){
                                        x= addressField.text+ s.name;
                                    } else {
                                        x = addressField.text+"/" + s.name;
                                    }
                                    _dirdownload = false;
                                    fileDownloader.startDownload(x,QGroundControl.settingsManager.appSettings.logSavePath+"/"+decodeURIComponent(s.name));
                                } else if(s.isDir && !fileDownloader.isBusy){
                                    _dirdownload = true;
                                    _downloadListDir = [];
                                    _downloadListFiles = [];
//                                    listView1.model = _indexModel;
//                                    _indexModel = listView1.model
                                    if(addressField.text.endsWith("/")){
                                        x= addressField.text;
                                    } else {
                                        x = addressField.text+"/";
                                    }
//                                    console.log("dir:",x);
                                    _root = {dir:s.fullname,path:x}
                                    x = x + s.fullname;
                                    fileDownloader.startDownloadIndex(x);
                                }

//                                console.log("selected index:",rowIndex);
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
//                                console.log("saved file:",file);
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

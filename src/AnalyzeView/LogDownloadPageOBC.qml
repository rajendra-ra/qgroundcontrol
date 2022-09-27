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
    property int _progress: 0
    property bool _dirdownload: false
    property var _root:null
    property var  _indexModel: fileDownloader.indexList
    property var _downloadListDir: []
    property var _downloadListFiles :[]
    property int _totalFiles:0

    QGCPalette { id: palette; colorGroupEnabled: enabled }

    Component {
        id: pageComponent

        ColumnLayout {
            width:  availableWidth
            height:  availableHeight
            Connections {
                target: fileDownloader
                onIndexingSuccessful:{
                    listView1.resizeColumnsToContents();
                    addressField.text = _url;
                    if(_dirdownload){
                        for(let i=0;i<_indexModel.count;i++){
                            let x = _indexModel.get(i)
                            let _path = _root.dir + x.url.split(_root.dir)[1]
                            let y = {url:x.url,path:_path}

                            if(x.isDir){
                                _downloadListDir.push(y);
                            } else {
                                _downloadListFiles.push(y);
                            }
                        }
                    } else {
                        _downloadListDir = []
                        _downloadListFiles = []
                    }

                }
                onGoingBusy:{ }
                onBackReady:{
                    if(_dirdownload){
                        if(_downloadListDir.length>0){
                        } else if(_downloadListFiles.length>0){
                        } else {
                            _totalFiles = 0;
                        }
                    } else {
                        downloadProgress.value = 0.0
                    }
                }
                onIsBusyChanged:{
                    if(!isBusy && _dirdownload){
                        if(_downloadListDir.length>0){
                            let _item = _downloadListDir.pop();
                            fileDownloader.startDownloadIndex(_item.url);
                        } else {
                            if(_downloadListFiles.length >0){
                                if(_totalFiles==0){
                                    _totalFiles = _downloadListFiles.length
                                }
                                let _item = _downloadListFiles.pop();
                                fileDownloader.startDownload(_item.url,QGroundControl.settingsManager.appSettings.logSavePath+"/"+decodeURIComponent(_item.path));
                            } else {
                                _dirdownload = false
                                fileDownloader.startDownloadIndex(_root.path);
                            }
                        }
                    }
                }

                onDownloadProgress:{
                    if(bytesTotal){
                        downloadProgress.value = bytesReceived*100/bytesTotal;
                        if(_dirdownload && _totalFiles){
                            downloadProgress.value = (1-_downloadListFiles.length)*100/_totalFiles;
                        }
                    } else {
                        downloadProgress.value = 0;
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight*1.5
                Layout.alignment: Qt.AlignTop
                id:addressRow

                TextField {
                    id:addressField
                    property string rootUri: "http://localhost:8080/"
                    text: "http://localhost:8080/"
                    placeholderText: "http://localhost:8080/"
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
                    onValueChanged: {_progress = value;}
                }
            }
            RowLayout {
                id:indexListLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
                TableView {
                    id: listView1
                    Layout.fillWidth: true
                    Layout.fillHeight:  true
                    model: _indexModel
                    Component.onCompleted: {}
                    rowDelegate: Rectangle {
                        height: 30
                        SystemPalette {
                              id: myPalette;
                              colorGroup: SystemPalette.Active
                       }
                       color: {
                          var baseColor = styleData.alternate?myPalette.alternateBase:myPalette.base
                          return styleData.selected?myPalette.highlight:baseColor
                       }
                    }

                    TableViewColumn {
                        title: qsTr("File")
                        width: ScreenTools.defaultFontPixelWidth * 6
                        horizontalAlignment: Text.AlignLeft
                        delegate : Text  {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 13
                            text: modelData?decodeURIComponent(modelData):""
                        }

                    }
                    onDoubleClicked: {
                       let s = listView1.model.get(row)
                        if(s.isDir){
                            let x = ""
                            if(addressField.text.endsWith("/")){
                                x = addressField.text+ s.fullname;
                            } else {
                                x = addressField.text+"/" + s.fullname;
                            }


                            fileDownloader.startDownloadIndex(x);
                        }
                    }
                }
                Column {
                    spacing:            _margin
                    Layout.alignment:   Qt.AlignTop | Qt.AlignLeft
                    QGCButton {
                        id: refreshBtn
                        enabled:    !fileDownloader.isBusy
                        text:       qsTr("Refresh")
                        width:      _butttonWidth
                        font.pointSize: 14
                        onClicked: {
                            fileDownloader.startDownloadIndex(addressField.text);
                        }
                    }
                    QGCButton {
                        id: downloadBtn
                        enabled:   listView1.selection.count > 0 && !fileDownloader.isBusy
                        text:       qsTr("Download")
                        width:      _butttonWidth
                        font.pointSize: 14
                        onClicked: {
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
                                    if(addressField.text.endsWith("/")){
                                        x= addressField.text;
                                    } else {
                                        x = addressField.text+"/";
                                    }
                                    _root = {dir:s.fullname,path:x}
                                    x = x + s.fullname;
                                    fileDownloader.startDownloadIndex(x);
                                }
                            })
                        }
                        QGCFileDialog {
                            id: fileDialog
                            onAcceptedForLoad: {
                                close()
                            }
                        }
                    }
                    QGCButton {
                        id: cancelBtn
                        enabled:    fileDownloader.isBusy
                        text:       qsTr("Cancel")
                        width:      _butttonWidth
                        font.pointSize: 14
                        onClicked: {
                            fileDownloader.abortDownload();
                        }
                    }
                }
            }
        }
    }
}

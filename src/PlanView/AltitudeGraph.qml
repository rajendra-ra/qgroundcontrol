import QtQuick          2.0
import QtQuick.Window   2.0
import QtQuick.Controls 2.3
import QtCharts         2.3

import QGroundControl               1.0

Item {
    id: _root
    property alias chart:chart
    property alias lineseries: lineseries
    property string labelColor: "#fff"

    property var missionController

    signal setCurrentSeqNum(int seqNum)
    signal updateSignal

    property var  _visualItems:         missionController.visualItems
    property real _altRange:            _maxAMSLAltitude - _minAMSLAltitude
    property real _indicatorSpacing:    5
    property real _minAMSLAltitude:     isNaN(missionController.minAMSLAltitude) ? 0 : missionController.minAMSLAltitude
    property real _maxAMSLAltitude:     isNaN(missionController.maxAMSLAltitude) ? 100 : missionController.maxAMSLAltitude
    property real _missionDistance:     isNaN(missionController.missionDistance) ? 100 : missionController.missionDistance
    property var  _unitsConversion:     QGroundControl.unitsConversion
    property bool _updateToggle:         true
    property var markers: []
    onUpdateSignal:_updateToggle = !_updateToggle
    implicitWidth: 800
    implicitHeight: 400
    ChartView {
        id:chart
        visible: true
        height:_root.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 0
        antialiasing: true
        backgroundColor:    "#ed000000"
        legend.visible:     false
        ValueAxis {
            id: xAxis
            labelsColor: labelColor
            min: 0
            max: _missionDistance
            tickCount: 4
        }
        ValueAxis {
            id: yAxis
            labelsColor: labelColor
            min: 0
            max: 0
            tickCount: 4
        }
        LineSeries {
            id:lineseries
            name: "LineSeries"
            axisX: xAxis
            axisY: yAxis
//            XYPoint { x: 0; y: 0 }
//            XYPoint { x: 5; y: 5 }
        }
        function adjustPosition(item, object) {
            let m_item = object
            var _startAlt = isNaN(_visualItems.get(0).coordinate.altitude)?0:_visualItems.get(0).coordinate.altitude
            var y;
            if(m_item.isSimpleItem){
                y = m_item.altitude.value+_startAlt
            } else {
                y= _startAlt
//                if(isNaN(y)){
//                  y = 0
//                }
            }

            let point = Qt.point(_visualItems.get(0).coordinate.distanceTo(m_item.coordinate), y)
            let position = chart.mapToPosition(point, lineseries)
            item.x = position.x - item.width / 2
            item.y = position.y - item.height / 2
            console.log("index:",object.sequenceNumber,"position:",point,_visualItems.get(0).coordinate.latitude,m_item.coordinate.latitude,y)
        }

        function adjustValue(item, index) {

            let m_item = _visualItems.get(index)
            let position = Qt.point(item.x + item.width / 2, item.y + item.height / 2)
            let point = chart.mapToValue(position, lineseries)

            if(m_item.isSimpleItem){
                m_item.altitude.value = point.y
                m_item.coordinateChanged(m_item.coordinate)
                console.log("adjusting ",index,"to y:",point.y,"altitude: ",m_item.altitude.value)
//                _root.updateSignal()
//                _root.update()
            }


//            lineModel.setProperty(index, "y", point.y)  // Change only Y-coordinate
            /*lineseries.replace(lineseries.at(index).x, lineseries.at(index).y, // old
                               lineseries.at(index).x, point.y) */               // new
        }
        Repeater {
            model:markers//_visualItems
            Rectangle {
                id: indicator
                radius: width
                width: 20
                height: width
                color: index ?((_visualItems.count-index-1)? "gray":"red") :"green"
                property real parentWidth: chart.width
                property real parentHeight: chart.height
                x:modelData.x-width/2
                y:modelData.y-height/2
//                property int index: object.sequenceNumber
//                property bool updateTriggered: _updateToggle
//                property var coordinate: object.coordinate
//                property var altitude: object.isSimpleItem?object.altitude.value:(object.coordinate.altitude?object.coordinate.altitude:0)
//                onCoordinateChanged: {
//                    console.log("coordinateChanged:index:",index,coordinate.latitude,"altitude:",altitude)
////                    chart.adjustPosition(this, index)
//                    _root.update()
//                }
//                onAltitudeChanged: chart.adjustPosition(this, index)
//                onParentWidthChanged: chart.adjustPosition(this, object)
//                onParentHeightChanged: chart.adjustPosition(this, object)
//                Binding on y {
////                    target: this
//                    value: getY(object)
//                    function getY(object){
//                        _root.update()
//                        var _startAlt = isNaN(_visualItems.get(0).coordinate.altitude)?0:_visualItems.get(0).coordinate.altitude
//                        var y;
//                        if(object.isSimpleItem){
//                            y = object.altitude.value+_startAlt
//                        } else {
//                            y= _startAlt
//            //                if(isNaN(y)){
//            //                  y = 0
//            //                }
//                        }

//                        let point = Qt.point(0, y)
//                        let position = chart.mapToPosition(point, lineseries)
////                        item.x = position.x - item.width / 2/*/
////                        item.y = position.y - item.height / 2*/
//                        return position.y
////                        if(object.isSimpleItem){
////                            return position.y//yobject.altitude.value
////                        }else {
////                            return object.coordinate.altitude?object.coordinate.altitude:0
////                        }
//                    }
//                }
//                Binding on x {
////                    target: this
//                    value: getX(object)
//                    function getX(object){
//                        _root.update()
//                        var _startX = _visualItems.get(0).coordinate.distanceTo(object.coordinate)
////                        var y;
////                        if(object.isSimpleItem){
////                            y = object.altitude.value+_startAlt
////                        } else {
////                            y= _startAlt
////            //                if(isNaN(y)){
////            //                  y = 0
////            //                }
////                        }

//                        let point = Qt.point(_startX, 0)
//                        let position = chart.mapToPosition(point, lineseries)
////                        item.x = position.x - item.width / 2/*/
////                        item.y = position.y - item.height / 2*/
//                        return position.x
////                        if(object.isSimpleItem){
////                            return position.y//yobject.altitude.value
////                        }else {
////                            return object.coordinate.altitude?object.coordinate.altitude:0
////                        }
//                    }
//                }

                onYChanged: {
                    if(mouseArea.drag.active) {
                        console.log("Mouse Drag:",y)
                        chart.adjustValue(this, index)
//                        _root.update()
//                        chart.adjustPosition(this, index)
                    }
                }
//                onUpdateTriggeredChanged: {
//                    chart.adjustPosition(this,object)
//                }

                Image {
                    id: waypoint
                    anchors.fill: parent
                    source: index *(_visualItems.count-index-1)? "qrc:/qmlimages/location.svg" :"qrc:/qmlimages/MapHomeBlack.svg"
                    sourceSize.height: height
                    sourceSize.width: width
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    drag.target: indicator
                    drag.axis: Drag.YAxis
                    preventStealing: true
                }
            }
        }
    }
    function update() {
//        updateSignal();
        var min=0,max=0;
        var _startAlt= _visualItems.get(0).coordinate.altitude
        if(isNaN(_startAlt)){
          _startAlt = 0
        }
        let t = new Array(0)
        for(var i=0;i<_visualItems.count;i++){
            var x,y;
            var item = _visualItems.get(i)
            x = item.distanceFromStart
            if(item.isSimpleItem){
                y = item.altitude.value+_startAlt
            } else {
                y= _startAlt
//                if(isNaN(y)){
//                  y = 0
//                }
            }
            min = Math.min(min,y)
            max = Math.max(max,y)
            if(i<lineseries.count){
                lineseries.remove(i);
                lineseries.insert(i,x,y);
            } else {
                lineseries.append(x,y);
            }
            t.push(Qt.point(x,y))
        }
        yAxis.min = min
        yAxis.max = max*1.2
        let tf = new Array(0)
        for(var j=0;j<t.length;j++){
            let p = chart.mapToPosition(t[j],lineseries)
            tf.push(p)
        }
        markers = tf

    }
}



/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";formeditorZoom:1.1}D{i:2}D{i:3}D{i:4}D{i:1}
}
##^##*/

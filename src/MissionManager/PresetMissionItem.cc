/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include <QStringList>
#include <QDebug>

#include "PresetMissionItem.h"
#include "FirmwarePluginManager.h"
#include "QGCApplication.h"
#include "JsonHelper.h"
#include "MissionCommandTree.h"
#include "MissionCommandUIInfo.h"
#include "QGroundControlQmlGlobal.h"
#include "SettingsManager.h"
#include "PlanMasterController.h"

PresetMissionItem::PresetMissionItem(PlanMasterController* masterController, bool flyView, VisualMissionItem* prevItem, bool forLoad)
    : SimpleMissionItem (masterController, flyView, forLoad)
    , _prevItem(prevItem)
{
    _init(forLoad);
}

PresetMissionItem::PresetMissionItem(MAV_CMD presetCmd, PlanMasterController* masterController,VisualMissionItem* prevItem, bool flyView)
    : SimpleMissionItem (masterController, flyView, false /* forLoad */)
    , _prevItem(prevItem)
{
    setCommand(presetCmd);
    if (isLandCommand(presetCmd)){
        setPrevPresetAtSameLocation(true);
    }
    _init(false);
}

PresetMissionItem::PresetMissionItem(PlanMasterController* masterController,VisualMissionItem* prevItem, bool flyView,const MissionItem& missionItem)
    : SimpleMissionItem (masterController, flyView, missionItem)
    , _prevItem(prevItem)
{
    _init(false);
}

PresetMissionItem::~PresetMissionItem()
{

}
void PresetMissionItem::_updateCoordinate(const QGeoCoordinate& coordinate){
    if(SimpleMissionItem::isLandCommand() && coordinate != this->coordinate()){
//        qDebug()<<"PresetMissionItem::updateCoordinate,CMD:"<<commandName();
        setCoordinate(coordinate);
    }
}
void PresetMissionItem::_init(bool forLoad)
{
    _editorQml = QStringLiteral("qrc:/qml/PresetItemEditor.qml");

    connect(_prevItem, &VisualMissionItem::coordinateChanged, this, &PresetMissionItem::prevCoordinateChanged);
    connect(_prevItem, &VisualMissionItem::coordinateChanged, this, &PresetMissionItem::_updateCoordinate);
    if (_flyView) {
        _initPrevPresetAtSameLocation();
        return;
    }

    QGeoCoordinate prevPosition = _prevItem->coordinate();
//    if (!previousPosition.isValid()) {
//        Vehicle* activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
//        if (activeVehicle) {
//            previousPosition = activeVehicle->homePosition();
//            if (homePosition.isValid()) {
//                _previousItem->setCoordinate(homePosition);
//            }
//        }
//    }

    if (forLoad) {
        // Load routines will set the rest up after load
        return;
    }

    _initPrevPresetAtSameLocation();
    if (_prevPresetAtSameLocation && prevPosition.isValid()) {
        SimpleMissionItem::setCoordinate(prevPosition);
    }

    // Wizard mode is set if:
    //  - Launch position is missing - requires prompt to user to click to set launch
    //  - Fixed wing - warn about climb out position adjustment
    if (!prevPosition.isValid() || _controllerVehicle->fixedWing()) {
        _wizardMode = true;
    }

    setDirty(false);
}

void PresetMissionItem::setPrevPresetAtSameLocation(bool prevPresetAtSameLocation)
{
    if (prevPresetAtSameLocation != _prevPresetAtSameLocation) {
        _prevPresetAtSameLocation = prevPresetAtSameLocation;
        if (_prevPresetAtSameLocation) {
            setPrevCoordinate(coordinate());
        }
        emit prevPresetAtSameLocationChanged(_prevPresetAtSameLocation);
        setDirty(true);
    }
}

void PresetMissionItem::setCoordinate(const QGeoCoordinate& coordinate)
{
//    qDebug()<<"PresetMissionItem::setCoordinate:"<<"MAV_CMD:"<<commandName();

    if (coordinate != this->coordinate()) {
        SimpleMissionItem::setCoordinate(coordinate);
        if (_prevPresetAtSameLocation) {
            _prevItem->setCoordinate(coordinate);
        }
    }
}
bool PresetMissionItem::isLandCommand(MAV_CMD command)
{
    return qgcApp()->toolbox()->missionCommandTree()->isLandCommand(command);
}
void PresetMissionItem::_initPrevPresetAtSameLocation(void)
{
    if (_prevPresetAtSameLocation && _prevItem->coordinate().isValid()) {
        setPrevPresetAtSameLocation(true);
    } else {
        setPrevPresetAtSameLocation(false);
    }
//    if (specifiesCoordinate()) {
//        if (_controllerVehicle->fixedWing() || _controllerVehicle->vtol()) {
//            setPreviousPresetAtSameLocation(false);
//        } else {
//            // PX4 specifies a coordinate for takeoff even for multi-rotor. But it makes more sense to not have a coordinate
//            // from and end user standpoint. So even for PX4 we try to keep launch and takeoff at the same position. Unless the
//            // user has moved/loaded launch at a different location than takeoff.
//            if (coordinate().isValid() && _previousItem->coordinate().isValid()) {
//                setPreviousPresetAtSameLocation(coordinate().latitude() == _previousItem->coordinate().latitude() && coordinate().longitude() == _previousItem->coordinate().longitude());
//            } else {
//                setPreviousPresetAtSameLocation(true);
//            }

//        }
//    } else {
//        setPreviousPresetAtSameLocation(true);
//    }
}

//bool PresetMissionItem::load(QTextStream &loadStream)
//{
//    bool success = SimpleMissionItem::load(loadStream);
//    if (success) {
//        _initLaunchPresetAtSameLocation();
//    }
//    _wizardMode = false; // Always be off for loaded items
//    return success;
//}

//bool PresetMissionItem::load(const QJsonObject& json, int sequenceNumber, QString& errorString)
//{
//    bool success = SimpleMissionItem::load(json, sequenceNumber, errorString);
//    if (success) {
//        _initLaunchPresetAtSameLocation();
//    }
//    _wizardMode = false; // Always be off for loaded items
//    return success;
//}

void PresetMissionItem::setPrevCoordinate(const QGeoCoordinate& prevCoordinate)
{
//    qDebug()<<"PresetMissionItem::setPrevCoordinate:"<<"MAV_CMD:"<<commandName()<<_prevPresetAtSameLocation;
    if (!prevCoordinate.isValid()) {
        return;
    }

    _prevItem->setCoordinate(prevCoordinate);

    if (!coordinate().isValid()) {
        QGeoCoordinate PresetCoordinate;
        if (_prevPresetAtSameLocation) {
            PresetCoordinate = prevCoordinate;
        } else {
            double distance = qgcApp()->toolbox()->settingsManager()->planViewSettings()->vtolTransitionDistance()->rawValue().toDouble(); // Default distance is VTOL transition to Preset point distance
            if (_controllerVehicle->fixedWing()) {
                double altitude = this->altitude()->rawValue().toDouble();

                if (altitudeMode() == QGroundControlQmlGlobal::AltitudeModeRelative) {
                    // Offset for fixed wing climb out of 30 degrees to specified altitude
                    if (altitude != 0.0) {
                        distance = altitude / tan(qDegreesToRadians(30.0));
                    }
                } else {
                    distance = altitude * 1.5;
                }
            }
            PresetCoordinate = prevCoordinate.atDistanceAndAzimuth(distance, 0);
        }
        SimpleMissionItem::setCoordinate(PresetCoordinate);
    }
}

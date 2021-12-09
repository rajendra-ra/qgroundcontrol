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

PresetMissionItem::PresetMissionItem(PlanMasterController* masterController, bool flyView, bool forLoad)
    : SimpleMissionItem (masterController, flyView, forLoad)
{
    _init(forLoad);
}

PresetMissionItem::PresetMissionItem(MAV_CMD presetCmd, PlanMasterController* masterController, bool flyView)
    : SimpleMissionItem (masterController, flyView, false /* forLoad */)
{
    setCommand(presetCmd);
    _init(false);
}

PresetMissionItem::PresetMissionItem(PlanMasterController* masterController, bool flyView,const MissionItem& missionItem)
    : SimpleMissionItem (masterController, flyView, missionItem)
{
    _init(false);
}

PresetMissionItem::~PresetMissionItem()
{

}

void PresetMissionItem::_init(bool forLoad)
{
    _editorQml = QStringLiteral("qrc:/qml/PresetItemEditor.qml");

//    connect(_settingsItem, &MissionSettingsItem::coordinateChanged, this, &PresetMissionItem::launchCoordinateChanged);

    if (_flyView) {
//        _initLaunchPresetAtSameLocation();
        return;
    }

//    QGeoCoordinate homePosition = _settingsItem->coordinate();
//    if (!homePosition.isValid()) {
//        Vehicle* activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
//        if (activeVehicle) {
//            homePosition = activeVehicle->homePosition();
//            if (homePosition.isValid()) {
//                _settingsItem->setCoordinate(homePosition);
//            }
//        }
//    }

    if (forLoad) {
        // Load routines will set the rest up after load
        return;
    }

//    _initLaunchPresetAtSameLocation();
//    if (_launchPresetAtSameLocation && homePosition.isValid()) {
//        SimpleMissionItem::setCoordinate(homePosition);
//    }

    // Wizard mode is set if:
    //  - Launch position is missing - requires prompt to user to click to set launch
    //  - Fixed wing - warn about climb out position adjustment
//    if (!homePosition.isValid() || _controllerVehicle->fixedWing()) {
//        _wizardMode = true;
//    }

    setDirty(false);
}

//void PresetMissionItem::setLaunchPresetAtSameLocation(bool launchPresetAtSameLocation)
//{
//    if (launchPresetAtSameLocation != _launchPresetAtSameLocation) {
//        _launchPresetAtSameLocation = launchPresetAtSameLocation;
//        if (_launchPresetAtSameLocation) {
//            setLaunchCoordinate(coordinate());
//        }
//        emit launchPresetAtSameLocationChanged(_launchPresetAtSameLocation);
//        setDirty(true);
//    }
//}

void PresetMissionItem::setCoordinate(const QGeoCoordinate& coordinate)
{
    if (coordinate != this->coordinate()) {
        SimpleMissionItem::setCoordinate(coordinate);
//        if (_launchPresetAtSameLocation) {
//            _settingsItem->setCoordinate(coordinate);
//        }
    }
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

//void PresetMissionItem::setLaunchCoordinate(const QGeoCoordinate& launchCoordinate)
//{
//    if (!launchCoordinate.isValid()) {
//        return;
//    }

//    _settingsItem->setCoordinate(launchCoordinate);

//    if (!coordinate().isValid()) {
//        QGeoCoordinate PresetCoordinate;
//        if (_launchPresetAtSameLocation) {
//            PresetCoordinate = launchCoordinate;
//        } else {
//            double distance = qgcApp()->toolbox()->settingsManager()->planViewSettings()->vtolTransitionDistance()->rawValue().toDouble(); // Default distance is VTOL transition to Preset point distance
//            if (_controllerVehicle->fixedWing()) {
//                double altitude = this->altitude()->rawValue().toDouble();

//                if (altitudeMode() == QGroundControlQmlGlobal::AltitudeModeRelative) {
//                    // Offset for fixed wing climb out of 30 degrees to specified altitude
//                    if (altitude != 0.0) {
//                        distance = altitude / tan(qDegreesToRadians(30.0));
//                    }
//                } else {
//                    distance = altitude * 1.5;
//                }
//            }
//            PresetCoordinate = launchCoordinate.atDistanceAndAzimuth(distance, 0);
//        }
//        SimpleMissionItem::setCoordinate(PresetCoordinate);
//    }
//}

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "SimpleMissionItem.h"
#include "MissionSettingsItem.h"

class PlanMasterController;

/// Preset mission item is a special case of a SimpleMissionItem which supports Launch Location display/editing
/// which is tied to home position.
class PresetMissionItem : public SimpleMissionItem
{
    Q_OBJECT

public:
    // Note: forLoad = true indicates that PresetMissionItem::load will be called onthe item
    PresetMissionItem(PlanMasterController* masterController, bool flyView, bool forLoad);
    PresetMissionItem(PlanMasterController* masterController, bool flyView, const MissionItem& missionItem);
    PresetMissionItem(MAV_CMD presetCmd, PlanMasterController* masterController, bool flyView);

//    Q_PROPERTY(QGeoCoordinate   previousCoordinate            READ previousCoordinate               WRITE setPreviousCoordinate NOTIFY previousCoordinateChanged)
//    Q_PROPERTY(bool             previousPresetAtSameLocation READ previousPresetAtSameLocation    WRITE setPreviousPresetAtSameLocation    NOTIFY previousPresetAtSameLocationChanged)

//    QGeoCoordinate  previousCoordinate            (void) const { return _settingsItem->coordinate(); }
//    bool            previousPresetAtSameLocation (void) const { return _previousPresetAtSameLocation; }

//    void setPreviousCoordinate            (const QGeoCoordinate& previousCoordinate);
//    void setPreviousPresetAtSameLocation (bool previousPresetAtSameLocation);

//    static bool isPresetCommand(MAV_CMD command);

    ~PresetMissionItem();

    // Overrides from VisualMissionItem
    void            setCoordinate           (const QGeoCoordinate& coordinate) override;
    double          specifiedFlightSpeed    (void) final { return std::numeric_limits<double>::quiet_NaN(); }
    double          specifiedGimbalYaw      (void) final { return std::numeric_limits<double>::quiet_NaN(); }
    double          specifiedGimbalPitch    (void) final { return std::numeric_limits<double>::quiet_NaN(); }
    QString         mapVisualQML            (void) const override { return QStringLiteral("SimpleItemMapVisual.qml"); }

    // Overrides from SimpleMissionItem
//    bool load(QTextStream &loadStream) final;
//    bool load(const QJsonObject& json, int sequenceNumber, QString& errorString) final;

    //void setDirty(bool dirty) final;

//signals:
//    void launchCoordinateChanged            (const QGeoCoordinate& launchCoordinate);
//    void launchPresetAtSameLocationChanged (bool launchPresetAtSameLocation);

private:
    void _init(bool forLoad);
//    void _initLaunchPresetAtSameLocation(void);

    MissionSettingsItem*    _settingsItem;
//    bool                    _launchPresetAtSameLocation = false;
};

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
    PresetMissionItem(PlanMasterController* masterController, bool flyView, VisualMissionItem* prevItem, bool forLoad);
    PresetMissionItem(PlanMasterController* masterController,VisualMissionItem* prevItem, bool flyView,const MissionItem& missionItem);
    PresetMissionItem(MAV_CMD presetCmd, PlanMasterController* masterController, VisualMissionItem* prevItem,bool flyView);

    Q_PROPERTY(QGeoCoordinate   prevCoordinate              READ prevCoordinate             WRITE setPrevCoordinate              NOTIFY prevCoordinateChanged)
    Q_PROPERTY(bool             prevPresetAtSameLocation    READ prevPresetAtSameLocation   WRITE setPrevPresetAtSameLocation    NOTIFY prevPresetAtSameLocationChanged)

    QGeoCoordinate  prevCoordinate           (void) const { return _prevItem->coordinate(); }
    bool            prevPresetAtSameLocation (void) const { return _prevPresetAtSameLocation; }

    void setPrevCoordinate            (const QGeoCoordinate& prevCoordinate);
    void setPrevPresetAtSameLocation (bool prevPresetAtSameLocation);
//    connect(this,)
    static bool isLandCommand(MAV_CMD command);

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

signals:
    void prevCoordinateChanged            (const QGeoCoordinate& prevCoordinate);
    void prevPresetAtSameLocationChanged  (bool prevPresetAtSameLocation);

private:
    void _init(bool forLoad);
    void _initPrevPresetAtSameLocation(void);
    void _updateCoordinate            (const QGeoCoordinate& coordinate);

    VisualMissionItem*      _prevItem;
    bool                    _prevPresetAtSameLocation = false;
};

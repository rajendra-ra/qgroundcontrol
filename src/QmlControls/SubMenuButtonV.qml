import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Layouts          1.0
import QtGraphicalEffects       1.0

import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0

// Important Note: SubMenuButtons must manage their checked state manually in order to support
// view switch prevention. This means they can't be checkable or autoExclusive.

Button {
    id:             _rootButton
    property bool   setupComplete:  true                                    ///< true: setup complete indicator shows as completed
    property bool   setupIndicator: true                                    ///< true: show setup complete indicator
    property var    imageColor:     undefined
    property string imageResource:  "/qmlimages/subMenuButtonImage.png"     ///< Button image
    property size   sourceSize:     Qt.size(ScreenTools.defaultFontPixelHeight * 5, ScreenTools.defaultFontPixelHeight * 5)

    text:               "Button"  ///< Pass in your own button text
    activeFocusOnPress: true

//    implicitHeight: ScreenTools.isTinyScreen ? ScreenTools.defaultFontPixelHeight * 3.5 : ScreenTools.defaultFontPixelHeight * 2.5
    implicitHeight:  __panel.implicitHeight

    onCheckedChanged: checkable = false

    style: ButtonStyle {
        id: buttonStyle

        QGCPalette {
            id:                 qgcPal
            colorGroupEnabled:  control.enabled
        }

        property bool showHighlight: control.pressed | control.checked

        background: Rectangle {
            id:     innerRect
            color:  showHighlight ? qgcPal.buttonHighlight : qgcPal.windowShade

            implicitWidth:innerColumn.width//+ScreenTools.defaultFontPixelWidth*2// titleBar.contentWidth + ScreenTools.defaultFontPixelWidth*2
            implicitHeight: innerColumn.height//+ScreenTools.defaultFontPixelWidth*2//titleBar.y + titleBar.contentHeight + ScreenTools.defaultFontPixelHeight
            ColumnLayout {
                id:innerColumn
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing:ScreenTools.defaultFontPixelHeight
                QGCColoredImage {
                    id:                     image
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.preferredHeight: 100
                    Layout.preferredWidth: 100
                    Layout.margins: ScreenTools.defaultFontPixelHeight
                    Layout.bottomMargin:0// ScreenTools.defaultFontPixelHeight
//                    anchors.topMargin:     ScreenTools.defaultFontPixelHeight
    //                anchors.top:           parent.top
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.horizontalCenter: parent.horizontalCenter
                    width:                  ScreenTools.defaultFontPixelHeight * 2
                    height:                 ScreenTools.defaultFontPixelHeight * 2
                    fillMode:               Image.PreserveAspectFit
                    mipmap:                 true
                    color:                  imageColor ? imageColor : (control.setupComplete ? qgcPal.button : "red")
                    source:                 control.imageResource
                    sourceSize:             _rootButton.sourceSize
//                    sourceSize: Qt.size(72,72)
                }

                QGCLabel {
                    id:                     titleBar
//                    anchors.topMargin:     ScreenTools.defaultFontPixelHeight
//                    anchors.top:           image.bottom
//                    anchors.horizontalCenterOffset: 0
//                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: ScreenTools.defaultFontPixelHeight
                    Layout.topMargin:0// ScreenTools.defaultFontPixelHeight
                    font.bold: true
                    color:                  showHighlight ? qgcPal.buttonHighlightText : qgcPal.buttonText
                    text:                   control.text
                }
            }
        }

        label: Item {}
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

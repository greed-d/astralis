import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.services
import qs.modules.common

RowLayout {
    id: root

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight
    ClippingWrapperRectangle {
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredHeight: 20
        Layout.preferredWidth: 20

        radius: width / 2
        visible: MprisService.artUrl && MprisService.artUrl !== ""

        Image {
            anchors.fill: parent
            source: MprisService.artUrl ? MprisService.artUrl : ""
            fillMode: Image.PreserveAspectCrop
        }
    }

    TextBox {
        text: MprisService.player ? (MprisService.player.trackTitle.length > 64 ? MprisService.player.trackTitle.slice(0, 64) + "..." : MprisService.player.trackTitle) : "No player"
        Layout.alignment: Qt.AlignVCenter
        color: MprisService.isPlaying ? Colors.text : Colors.textMuted
    }

    WrapperMouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button == Qt.LeftButton) {
                MprisService.togglePlaybackState();
            } else if (mouse.button == Qt.RightButton) {
                MprisService.next();
            }
        }
        cursorShape: Qt.PointingHandCursor
    }
}

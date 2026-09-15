import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.icons

Item {
    id: root

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout
        anchors.fill: parent

        ClippingWrapperRectangle {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: 20
            Layout.preferredWidth: 20

            radius: 20
            visible: MprisService.artUrl && MprisService.artUrl !== ""

            Image {
                anchors.fill: parent
                source: MprisService.artUrl ? MprisService.artUrl : ""
                fillMode: Image.PreserveAspectCrop
            }
        }
        MusicNote {
            visible: MprisService.artUrl == ""
            iconColor: Colors.text
        }

        TextBox {
            Layout.preferredWidth: -1
            Layout.maximumWidth: 190
            elide: Text.ElideRight           // truncate visually instead of overflowing
            text: MprisService.player ? (MprisService.player.trackTitle?.length > 64 ? MprisService.player.trackTitle.slice(0, 64) + "..." : MprisService.player.trackTitle) : "No player"
            Layout.alignment: Qt.AlignVCenter
            color: MprisService.isPlaying ? Colors.text : Colors.textDisabled
        }
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
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                PipewireService.volumeUp(0.05);
            } else {
                PipewireService.volumeDown(0.05);
            }
        }
        cursorShape: Qt.PointingHandCursor
    }
}

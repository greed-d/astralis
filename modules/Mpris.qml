import QtQuick
import Quickshell
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.services
import qs.modules.common

RowLayout {
    id: root

    Item {
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredHeight: 20
        Layout.preferredWidth: 20
        visible: MprisService.artUrl && MprisService.artUrl !== ""

        Image {
            id: imgSource
            anchors.fill: parent
            source: MprisService.artUrl ? MprisService.artUrl : ""
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        Rectangle {
            id: maskSource
            anchors.fill: parent
            radius: width / 2 // Or e.g. 4 for subtle rounded corners
            visible: false
        }

        OpacityMask {
            anchors.fill: parent
            source: imgSource
            maskSource: maskSource
        }
    }

    TextBox {
        text: MprisService.player ? (MprisService.player.trackTitle.slice(0, 120) + " . " + MprisService.player.trackArtist) : "No player"
        Layout.alignment: Qt.AlignVCenter
        color: MprisService.isPlaying ? Colors.text : Colors.textMuted
    }

    MouseArea {
        anchors.fill: parent
        onClicked: MprisService.togglePlaybackState()
        cursorShape: Qt.PointingHandCursor
    }
}

import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.services
import qs.modules.common

RowLayout {
    id: root
    readonly property var fontConfig: Config.theme.font
    property string fontFamily: fontConfig.family
    property string fontSize: fontConfig.family

    Image {
        source: MprisService.artUrl ? MprisService.artUrl : "None"
        Layout.preferredHeight: 20
        Layout.preferredWidth: 20
        fillMode: Image.PreserveAspectCrop
        visible: MprisService.artUrl !== ""
        layer.enabled: true
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

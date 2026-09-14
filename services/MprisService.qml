pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import qs.modules.common

Singleton {
    id: root
    property MprisPlayer player: Mpris.players.values[0] ?? null

    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string album: player?.trackAlbum ?? ""
    readonly property string artUrl: player?.trackArtUrl ?? ""

    readonly property bool isPlaying: player?.isPlaying ?? false
    readonly property bool canPlay: player?.canPlay ?? false
    readonly property bool canPause: player?.canPause ?? false
    readonly property bool canGoNext: player?.canGoNext ?? false
    readonly property bool canGoPrevious: player?.canGoPrevious ?? false
    readonly property bool canSeek: player?.canSeek ?? false

    readonly property int state: player?.playbackState

    readonly property real volume: player?.volume ?? 0.0
    readonly property real length: player?.length ?? 0.0
    readonly property real position: player?.position ?? 0.0
    Component.onCompleted: {
        console.log("============== MPRIS LOGS ==========");
        console.log("[MprisWidget] player:", root.player);
        console.log("[MprisWidget] trackTitle:", root.title);
        console.log("[MprisWidget] trackArtist:", root.artist);
        console.log("[MprisWidget] trackUrl:", root.artUrl);
        console.log("[MprisWidget] canGoNext:", root.canGoNext);
        console.log("[MprisWidget] length:", root.length / 60);
        console.log("[MprisWidget] position:", root.position / 60);
        console.log("[MprisWidget] state:", root.state);
        console.log("[MprisWidget] volume:", root.volume);
        console.log("[MprisWidget] state:", Types.playbackStateToString(root.state));
        console.log("=======================================");
    }

    Connections {
        target: MprisService
        function onPlayerChanged() {
            console.log("[MprisWidget] player changed:", root.player);
        }
    }

    function togglePlaybackState() {
        if (player && root.state === 1) {
            player.pause();
        } else {
            player.play();
        }
    }

    function next() {
        if (player && canGoNext)
            player.next();
    }
    function previous() {
        if (player && canGoPrevious)
            player.previous();
    }
}

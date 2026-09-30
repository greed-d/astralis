pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQml
import qs.modules.common

Singleton {
    id: root

    // The actual sticky state — not recomputed from scratch each time
    property MprisPlayer player: null

    // --- Initial pick on startup / when list first populates ---
    function pickInitial() {
        const players = Mpris.players.values;
        return players.find(p => p.isPlaying) ?? players.find(p => p.canPlay) ?? null;
    }

    Component.onCompleted: player = pickInitial()

    // --- Watch for players being added/removed ---
    Connections {
        target: Mpris.players

        function onValuesChanged() {
            const players = Mpris.players.values;

            // If our current player got closed/removed, fall back
            if (root.player && !players.includes(root.player)) {
                root.player = players.find(p => p.isPlaying) ?? players.find(p => p.canPlay) ?? null;
            }

            // If we have no player yet, try to pick one
            if (!root.player) {
                root.player = root.pickInitial();
            }
        }
    }

    // --- Watch each player for becoming active; switch stickily ---
    Instantiator {
        model: Mpris.players.values
        active: true

        delegate: Connections {
            target: modelData

            function onIsPlayingChanged() {
                if (modelData.isPlaying) {
                    // A player started playing -> it becomes the active one
                    root.player = modelData;
                }
                // If it paused, do nothing — keep it as the shown player
                // until something else starts playing or it's removed.
            }
        }
    }

    function formatTime(sec) {
        if (!sec || sec < 0)
            return "0:00";
        const total = Math.floor(sec);
        const h = Math.floor(total / 3600);
        const m = Math.floor((total % 3600) / 60);
        const s = total % 60;
        const ss = s.toString().padStart(2, "0");
        if (h > 0)
            return `${h}:${m.toString().padStart(2, "0")}:${ss}`;
        return `${m.toString().padStart(2, "0")}:${ss}`;
    }

    readonly property string playerName: player?.identity ?? "No player"
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

    readonly property int state: player?.playbackState ?? 0

    readonly property real volume: player?.volume ?? 0.0
    readonly property real length: player?.length ?? 0.0
    readonly property real position: player?.position ?? 0.0

    readonly property string positionText: formatTime(position)
    readonly property string lengthText: formatTime(length)
    function togglePlaybackState() {
        if (!player)
            return;

        if (player.isPlaying) {
            player.pause();
        } else if (player.canPlay) {
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
    Timer {
        interval: 1000
        repeat: true
        running: root.isPlaying && root.player !== null
        onTriggered: root.player.positionChanged()
    }
}

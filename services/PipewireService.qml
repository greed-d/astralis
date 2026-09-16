pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root

    readonly property PwNode defaultSink: Pipewire.defaultAudioSink
    readonly property PwNode defaultSource: Pipewire.defaultAudioSource

    PwObjectTracker {
        objects: [root.defaultSink, root.defaultSource]
    }

    readonly property real volume: defaultSink?.audio?.volume ?? 0.0
    readonly property bool muted: defaultSink?.audio?.muted ?? false
    readonly property string sinkName: defaultSink?.description ?? "No Output Device"

    readonly property real inputVolume: defaultSource?.audio?.volume ?? 0.0
    readonly property bool inputMuted: defaultSource?.audio?.muted ?? false
    readonly property string sourceName: defaultSource?.description ?? "No Input Device"

    readonly property var sinks: Pipewire.nodes.values.filter(node => node.isSink && !node.isVirtual)

    readonly property var sources: Pipewire.nodes.values.filter(node => node.isSource && !node.isVirtual)

    // function logAll() {
    //     console.log("============== PIPEWIRE LOGS ==========");
    //     console.log("[Pipewire] defaultSink:", defaultSink);
    //     console.log("[Pipewire] defaultSource:", defaultSource);
    //     console.log("[Pipewire] volume:", volume);
    //     console.log("[Pipewire] ismuted:", muted);
    //     console.log("[Pipewire] sinkName:", sinkName);
    //     console.log("[Pipewire] inputVolume:", inputVolume);
    //     console.log("[Pipewire] inputMuted:", inputMuted);
    //     console.log("[Pipewire] sourceName:", sourceName);
    //     console.log("[Pipewire] sinks:", sinks.map(n => n.description));
    //     console.log("[Pipewire] sources:", sources.map(n => n.description));
    //     console.log("=======================================");
    // }

    // Component.onCompleted: logAll()

    // onVolumeChanged: console.log("START LOG CHANGE PIPEWIRE ===============[Pipewire] volume changed:===============", volume)
    // onMutedChanged: console.log("[Pipewire] muted changed:", muted)
    // onSinkNameChanged: console.log("[Pipewire] sinkName changed:", sinkName)
    // onInputVolumeChanged: console.log("[Pipewire] inputVolume changed:", inputVolume)
    // onInputMutedChanged: console.log("[Pipewire] inputMuted changed:", inputMuted)
    // onSourceNameChanged: console.log("[Pipewire] sourceName changed:", sourceName)
    // onSinksChanged: console.log("[Pipewire] sinks changed:", sinks.map(n => n.description))
    // onSourcesChanged: console.log("[Pipewire] sources changed:", sources.map(n => n.description))

    function setVolume(val) {
        if (defaultSink?.audio) {
            defaultSink.audio.volume = Math.max(0.0, Math.min(1.5, val));
        }
    }

    function volumeUp(step = 0.05) {
        setVolume(volume + step);
    }

    function volumeDown(step = 0.05) {
        setVolume(volume - step);
    }

    function toggleMute() {
        if (defaultSink?.audio) {
            defaultSink.audio.muted = !defaultSink.audio.muted;
        }
    }

    function setDefaultSink(node) {
        if (node && node.isSink) {
            Pipewire.preferredDefaultAudioSink = node;
        }
    }

    function setDefaultSource(node) {
        if (node && node.isSource) {
            Pipewire.preferredDefaultAudioSource = node;
        }
    }

    function setNodeVolume(node, val) {
        if (node?.audio) {
            node.audio.volume = Math.max(0.0, Math.min(1.5, val));
        }
    }

    function toggleNodeMute(node) {
        if (node?.audio) {
            node.audio.muted = !node.audio.muted;
        }
    }
}

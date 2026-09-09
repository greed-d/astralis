pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Networking
import qs.modules.common

Singleton {
    id: root

    property real rateUp: 0.0
    property real rateDown: 0.0
    property string wanIP: ""
    property int updateInterval: Config.data.network.externalUpdateInterval

    // Concise device & network lookups using Array.find and optional chaining
    readonly property var activeDevice: Networking.devices.values.find(d => d.connected) ?? null
    readonly property var activeNetwork: activeDevice?.networks.values.find(n => n.connected) ?? null

    readonly property string activeInterface: activeDevice?.name ?? ""
    readonly property string deviceName: activeInterface
    readonly property string networkType: activeDevice ? DeviceType.toString(activeDevice.type) : "Unknown"
    readonly property string connectedStatus: activeDevice ? ConnectionState.toString(activeDevice.state) : "unknown"

    readonly property string ssid: activeNetwork?.name ?? ""
    readonly property int signalStrength: activeNetwork ? Math.round(activeNetwork.signalStrength * 100) : 0

    Timer {
        interval: root.updateInterval
        repeat: true
        running: root.networkType === "Wifi" && root.activeDevice !== null
        onTriggered: root.activeDevice.scannerEnabled = true
    }
}

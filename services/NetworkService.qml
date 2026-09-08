pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Networking

Singleton {
    id: root

    // Common
    property real rateUp: 0.0
    property real rateDown: 0.0
    property string wanIP: ""

    readonly property var activeDevice: {
        for (const device of Networking.devices.values) {
            if (device.connected)
                return device;
        }
        return null;
    }

    readonly property var activeNetwork: {
        if (!activeDevice)
            return null;
        for (const network of activeDevice.networks.values) {
            if (network.connected)
                return network;
        }
        return null;
    }

    property string activeInterface: activeDevice ? activeDevice.name : ""
    property string deviceName: activeDevice ? activeDevice.name : ""
    property string networkType: activeDevice ? DeviceType.toString(activeDevice.type) : "Unknown"

    property string connectedStatus: activeDevice ? ConnectionState.toString(activeDevice.state) : "unknown"
    property string ssid: activeNetwork ? activeNetwork.name : ""
    property int signalStrength: activeNetwork ? Math.round(activeNetwork.signalStrength * 100) : 0
}

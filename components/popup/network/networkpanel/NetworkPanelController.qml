import QtQuick
import Quickshell.Networking

QtObject {
    id: root

    property bool active: false
    property string selected: ""

    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property var networks: {
        const n = wifiDevice ? wifiDevice.networks.values : [];
        return [...n].sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength));
    }

    onActiveChanged: {
        if (wifiDevice)
            wifiDevice.scannerEnabled = active;
        if (!active)
            selected = "";
    }

    function tier(frac) {
        return frac >= 0.75 ? 3 : frac >= 0.5 ? 2 : frac >= 0.25 ? 1 : 0;
    }
    function toggleSelected(name) {
        selected = selected === name ? "" : name;
    }
    function setWifiEnabled(on) {
        Networking.wifiEnabled = on;
    }
    function connectTo(net, psk) {
        psk ? net.connectWithPsk(psk) : net.connect();
    }
    function disconnectFrom(net) {
        net.disconnect();
    }
    function forget(net) {
        net.forget();
        selected = "";
    }
}

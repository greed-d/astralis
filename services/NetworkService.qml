pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick
import qs.modules.common

Singleton {
    id: root

    // ---------------------------------------------------------------------
    // Traffic counters (preserved from the original service)
    // ---------------------------------------------------------------------
    property real rateUp: 0.0
    property real rateDown: 0.0
    property string wanIP: ""
    property int updateInterval: Config.data.network.externalUpdateInterval

    // ---------------------------------------------------------------------
    // Devices / active connection
    // ---------------------------------------------------------------------
    readonly property var activeDevice: Networking.devices.values.find(d => d.connected) ?? null
    readonly property var activeNetwork: activeDevice?.networks.values.find(n => n.connected) ?? null
    readonly property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null

    readonly property string activeInterface: activeDevice?.name ?? ""
    readonly property string deviceName: activeInterface
    readonly property string networkType: activeDevice ? DeviceType.toString(activeDevice.type) : "Unknown"
    readonly property string connectedStatus: activeDevice ? ConnectionState.toString(activeDevice.state) : "unknown"

    readonly property bool isWifi: activeDevice?.type === DeviceType.Wifi
    readonly property bool isWired: activeDevice?.type === DeviceType.Wired
    readonly property bool connected: activeDevice?.connected ?? false
    readonly property bool disconnected: !root.connected

    // ---------------------------------------------------------------------
    // Active wifi network
    // ---------------------------------------------------------------------
    readonly property string ssid: activeNetwork?.name ?? ""
    readonly property int signalStrength: activeNetwork ? Math.round(activeNetwork.signalStrength * 100) : 0
    readonly property real signalFraction: activeNetwork ? activeNetwork.signalStrength : 0.0
    readonly property string security: (root.isWifi && activeNetwork) ? root.securityLabel(activeNetwork.security) : ""

    // ---------------------------------------------------------------------
    // Wifi controls
    // ---------------------------------------------------------------------
    readonly property bool wifiAvailable: wifiDevice !== null
    readonly property bool wifiHardwareEnabled: Networking.wifiHardwareEnabled
    readonly property bool wifiEnabled: Networking.wifiEnabled

    // Scanning is owned by the service so the popup stays presentation-only.
    property bool scanning: false
    onScanningChanged: if (wifiDevice)
        wifiDevice.scannerEnabled = scanning
    onWifiDeviceChanged: {
        if (wifiDevice)
            wifiDevice.scannerEnabled = scanning;
        root.rebuildNetworks();
    }

    // Stable, connected-first, signal-descending list of visible networks.
    //
    // This is rebuilt imperatively (rather than as a binding) so that the
    // array identity only changes when membership or connection state
    // changes. Rebuilding on every signal update would make `Repeater`
    // destroy and recreate delegates, which would break an in-progress
    // password entry. Row content binds to each `net` object directly, so
    // signal strength still updates live.
    property var networks: []
    readonly property int networkCount: networks.length

    function rebuildNetworks() {
        const dev = root.wifiDevice;
        if (!dev) {
            if (root.networks.length > 0)
                root.networks = [];
            return;
        }
        const sorted = [...dev.networks.values].sort((a, b) => (b.connected - a.connected) || (b.signalStrength - a.signalStrength));
        const same = sorted.length === root.networks.length && sorted.every((n, i) => n === root.networks[i]);
        if (!same)
            root.networks = sorted;
    }

    Connections {
        target: root.wifiDevice?.networks ?? null
        ignoreUnknownSignals: true
        function onValuesChanged() {
            root.rebuildNetworks();
        }
    }

    // Only one network can be connected at a time, so the active network
    // changing (connect, disconnect, or switch) is enough to keep the
    // connected-first ordering correct. `activeNetwork` is a binding that
    // reads every network's `connected`, so it re-evaluates on any change.
    onActiveNetworkChanged: root.rebuildNetworks()

    Component.onCompleted: root.rebuildNetworks()

    // ---------------------------------------------------------------------
    // Connection details not exposed by Quickshell.Networking, gathered
    // from NetworkManager / iw. Everything degrades gracefully to "" when
    // a tool or field is unavailable.
    // ---------------------------------------------------------------------
    property var linkInfo: ({})

    readonly property real frequencyMHz: Number(linkInfo.FREQ) || 0
    readonly property string frequencyGHz: frequencyMHz > 0 ? (frequencyMHz / 1000).toFixed(3).replace(/\.?0+$/, "") : ""
    readonly property string band: {
        if (frequencyMHz <= 0)
            return "";
        if (frequencyMHz >= 5925)
            return "6 GHz";
        if (frequencyMHz >= 4900)
            return "5 GHz";
        if (frequencyMHz >= 2400)
            return "2.4 GHz";
        return "";
    }
    readonly property string linkSpeed: {
        if (root.isWifi && linkInfo.RXBITRATE)
            return linkInfo.RXBITRATE + " Mbit/s";
        if (root.isWired && activeDevice?.linkSpeed > 0)
            return activeDevice.linkSpeed + " Mbit/s";
        return "";
    }
    readonly property string signalDbm: linkInfo.SIGNAL ? linkInfo.SIGNAL + " dBm" : ""
    readonly property string ipAddress: linkInfo["IP4.ADDRESS"] ?? ""
    readonly property string gateway: linkInfo["IP4.GATEWAY"] ?? ""
    readonly property string dns: linkInfo["IP4.DNS"] ?? ""
    readonly property string macAddress: activeDevice?.address ?? ""

    // ---------------------------------------------------------------------
    // Helpers / actions
    // ---------------------------------------------------------------------
    function tier(frac) {
        return frac >= 0.75 ? 3 : frac >= 0.5 ? 2 : frac >= 0.25 ? 1 : 0;
    }

    function securityLabel(sec) {
        switch (sec) {
        case WifiSecurityType.Open:
            return "Open";
        case WifiSecurityType.WpaPsk:
            return "WPA";
        case WifiSecurityType.Wpa2Psk:
            return "WPA2";
        case WifiSecurityType.Wpa3SuiteB192:
            return "WPA3";
        case WifiSecurityType.Sae:
            return "WPA3-SAE";
        case WifiSecurityType.WpaEap:
            return "WPA-Enterprise";
        case WifiSecurityType.Wpa2Eap:
            return "WPA2-Enterprise";
        case WifiSecurityType.StaticWep:
        case WifiSecurityType.DynamicWep:
            return "WEP";
        case WifiSecurityType.Leap:
            return "LEAP";
        case WifiSecurityType.Owe:
            return "OWE";
        default:
            return "Unknown";
        }
    }

    function connectionFailureMessage(reason) {
        switch (reason) {
        case ConnectionFailReason.NoSecrets:
            return "Incorrect password. Please try again.";
        case ConnectionFailReason.WifiAuthTimeout:
            return "Authentication timed out.";
        case ConnectionFailReason.WifiNetworkLost:
            return "Network is out of range.";
        case ConnectionFailReason.WifiClientDisconnected:
            return "Disconnected by the network.";
        case ConnectionFailReason.WifiClientFailed:
            return "Could not connect to the network.";
        default:
            return "Connection failed. Please try again.";
        }
    }

    function setWifiEnabled(on) {
        Networking.wifiEnabled = on;
    }

    function connectTo(net, psk) {
        if (!net)
            return;
        if (psk && psk.length > 0)
            net.connectWithPsk(psk);
        else
            net.connect();
    }

    function disconnectFrom(net) {
        if (net)
            net.disconnect();
    }

    function forget(net) {
        if (net)
            net.forget();
    }

    // Trigger a fresh scan. The scanner is left in whatever state `scanning`
    // currently holds so an open popup keeps receiving live updates.
    function rescan() {
        if (!wifiDevice)
            return;
        wifiDevice.scannerEnabled = false;
        Qt.callLater(() => {
            if (wifiDevice)
                wifiDevice.scannerEnabled = root.scanning;
        });
    }

    function refreshLinkInfo() {
        if (!linkInfoProcess.running)
            linkInfoProcess.running = true;
    }

    function parseLinkInfo(text) {
        const info = ({});
        const lines = text.split("\n");
        for (const line of lines) {
            if (!line)
                continue;
            const idx = line.indexOf("|");
            if (idx < 0)
                continue;
            const key = line.slice(0, idx).replace(/\[\d+\]$/, "");
            const value = line.slice(idx + 1).trim();
            if (value.length > 0)
                info[key] = value;
        }
        root.linkInfo = info;
    }

    // ---------------------------------------------------------------------
    // Link detail polling
    // ---------------------------------------------------------------------
    Process {
        id: linkInfoProcess
        command: ["sh", "-c", `
            iface=$(nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | awk -F: '$2=="wifi" && $3 ~ /^connected/ {print $1; exit}')
            if [ -z "$iface" ]; then
                iface=$(nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | awk -F: '$2=="ethernet" && $3 ~ /^connected/ {print $1; exit}')
            fi
            [ -z "$iface" ] && exit 0
            nmcli -t -f IP4.ADDRESS,IP4.GATEWAY,IP4.DNS device show "$iface" 2>/dev/null | sed 's/:/|/'
            if command -v iw >/dev/null 2>&1; then
                iw dev "$iface" link 2>/dev/null | awk '/freq:/{print "FREQ|"$2} /signal:/{print "SIGNAL|"$2} /rx bitrate:/{print "RXBITRATE|"$3}'
            fi
        `]
        stdout: StdioCollector {
            onStreamFinished: root.parseLinkInfo(this.text)
        }
    }

    Timer {
        interval: Math.max(1000, root.updateInterval)
        repeat: true
        running: root.activeInterface !== ""
        triggeredOnStart: true
        onTriggered: root.refreshLinkInfo()
    }

    onActiveInterfaceChanged: {
        if (root.activeInterface !== "")
            root.refreshLinkInfo();
        else
            root.linkInfo = ({});
    }
}

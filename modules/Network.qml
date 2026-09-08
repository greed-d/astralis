// modules/Network.qml
import QtQuick.Shapes
import QtQuick
import Quickshell.Networking
import qs.modules.common
import qs.modules.icons
import qs.services

Row {
    id: root
    spacing: Config.data.network.icon.enabled ? 6 : 0
    property int iconHeight: 20
    property real iconSize: Config.data.theme.font.size * Config.data.network.icon.scale
    property string iconColor: Config.data.network.icon.color
    property string textColor: Config.data.theme.colors.text
    property string fontFamily: Config.data.theme.font.family
    property int fontSize: Config.data.theme.font.size

    readonly property var networkType: NetworkService.networkType
    readonly property bool isWifi: networkType == "Wifi"
    readonly property bool isLan: networkType == "Wired"
    readonly property int wifiTier: NetworkService.signalStrength >= 75 ? 3 : NetworkService.signalStrength >= 50 ? 2 : NetworkService.signalStrength >= 25 ? 1 : 0

    Timer {
        interval: 1000
        repeat: true
        running: root.isWifi
        onTriggered: NetworkService.activeDevice.scannerEnabled = true
    }

    SignalWifiOff {
        visible: Config.data.network.icon.enabled && !root.isWifi && !root.isLan
        anchors.verticalCenter: parent.verticalCenter
        iconHeight: root.iconSize
        iconColor: root.iconColor
    }
    Text {
        visible: Config.data.network.icon.enabled && !root.isWifi && !root.isLan
        text: "Disconnected"
        color: root.iconColor
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }

    Loader {
        anchors.verticalCenter: parent.verticalCenter
        active: Config.data.network.icon.enabled && root.isWifi
        sourceComponent: [wifiIcon1, wifiIcon2, wifiIcon3, wifiIcon4][root.wifiTier]
    }

    Component {
        id: wifiIcon1
        WifiIcon1Bar {
            iconHeight: root.iconSize
            iconColor: root.iconColor
        }
    }
    Component {
        id: wifiIcon2
        WifiIcon2Bar {
            iconHeight: root.iconSize
            iconColor: root.iconColor
        }
    }
    Component {
        id: wifiIcon3
        WifiIcon3Bar {
            iconHeight: root.iconSize
            iconColor: root.iconColor
        }
    }
    Component {
        id: wifiIcon4
        WifiIcon4Bar {
            iconHeight: root.iconSize
            iconColor: root.iconColor
        }
    }
    Text {
        visible: root.isWifi && NetworkService.ssid !== ""
        text: NetworkService.signalStrength + "%"
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: iconSize
    }
    LanConnectedIcon {
        visible: root.isLan
        anchors.verticalCenter: parent.verticalCenter
        iconHeight: root.iconSize
        iconColor: root.iconColor
    }

    Text {
        visible: root.isLan
        text: "Connected"
        color: root.textColor
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }
}

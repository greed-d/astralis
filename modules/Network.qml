import QtQuick.Shapes
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import qs.modules.common
import qs.modules.icons
import qs.services

RowLayout {
    id: root
    spacing: iconEnabled ? 6 : 0

    // Config Shortcuts
    readonly property var netConfig: Config.data.network.icon
    readonly property var fontConfig: Config.theme.font

    property real iconSize: fontConfig.size * netConfig.scale
    property string iconColor: netConfig.color
    property bool iconEnabled: netConfig.enabled
    property bool iconVisible: netConfig.visible
    property string textColor: Config.theme.colors.text
    property string fontFamily: fontConfig.family
    property int fontSize: fontConfig.size

    // Network State Helpers
    readonly property string networkType: NetworkService.networkType
    readonly property bool isWifi: networkType === "Wifi"
    readonly property bool isLan: networkType === "Wired"
    readonly property bool isDisconnected: !isWifi && !isLan

    readonly property int signal: NetworkService.signalStrength
    readonly property int wifiTier: signal >= 75 ? 3 : signal >= 50 ? 2 : signal >= 25 ? 1 : 0

    // Icons
    SignalWifiOff {
        visible: root.iconEnabled && root.isDisconnected
        Layout.alignment: Qt.AlignVCenter
        iconHeight: root.iconSize
        iconColor: root.iconColor
    }

    WifiIcon {
        visible: root.iconEnabled && root.isWifi
        Layout.alignment: Qt.AlignVCenter
        tier: root.wifiTier
        iconHeight: root.iconSize
        iconColor: "white"
    }

    LanConnectedIcon {
        visible: root.isLan && root.iconVisible
        Layout.alignment: Qt.AlignVCenter
        iconHeight: root.iconSize
        iconColor: root.iconColor
    }

    // Consolidated Text Element
    Text {
        visible: root.isDisconnected || (root.isWifi && NetworkService.ssid !== "") || root.isLan
        text: root.isDisconnected ? "Disconnected" : root.isWifi ? `${NetworkService.ssid} ( ${root.signal}% )` : "Connected"
        color: root.isDisconnected ? root.iconColor : root.textColor
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }
}

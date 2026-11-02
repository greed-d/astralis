import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

PopupWindow {
    id: popupNet
    property Item anchorItem: null
    property bool shown: false

    property bool suppressed: false      // true while the click panel is open
    property bool delayedShown: false

    visible: shown
    implicitWidth: 220
    implicitHeight: col.implicitHeight + 24

    anchor.item: anchorItem
    anchor.rect.x: anchorItem ? (anchorItem.width / 2 - implicitWidth / 2) : 0
    anchor.rect.y: anchorItem ? anchorItem.height + 13 : 0
    color: "transparent"

    readonly property bool isWifi: NetworkService.networkType === "Wifi"
    readonly property bool isLan: NetworkService.networkType === "Wired"
    readonly property bool isDisconnected: !isWifi && !isLan

    component InfoRow: RowLayout {
        property string label
        property string value
        Layout.fillWidth: true
        TextBox {
            text: label
            color: Colors.overlay2
        }
        Item {
            Layout.fillWidth: true
        }
        TextBox {
            text: value
            font.weight: Font.DemiBold
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Colors.background2
        border {
            color: Colors.border
            width: 1
        }

        ColumnLayout {
            id: col
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 6

            TextBox {
                text: popupNet.isWifi ? "Wi-Fi" : popupNet.isLan ? "Ethernet" : "Disconnected"
                font.pixelSize: 16
                font.weight: Font.DemiBold
            }

            InfoRow {
                visible: !popupNet.isDisconnected
                label: "Interface"
                value: NetworkService.activeInterface
            }
            InfoRow {
                visible: popupNet.isWifi
                label: "SSID"
                value: NetworkService.ssid
            }
            InfoRow {
                visible: popupNet.isWifi
                label: "Signal"
                value: NetworkService.signalStrength + "%"
            }
        }
    }
}

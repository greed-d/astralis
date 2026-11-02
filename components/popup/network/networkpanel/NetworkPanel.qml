import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.icons
import qs.services

PopupWindow {
    id: win
    property Item anchorItem: null
    property bool open: false

    visible: open
    implicitWidth: 360
    implicitHeight: card.implicitHeight
    color: "transparent"

    anchor.item: anchorItem
    anchor.rect.x: anchorItem ? (anchorItem.width / 2 - implicitWidth / 2) : 0
    anchor.rect.y: anchorItem ? anchorItem.height + 13 : 0

    readonly property bool isWifi: NetworkService.networkType === "Wifi"
    readonly property bool isLan: NetworkService.networkType === "Wired"
    readonly property bool isDisconnected: !isWifi && !isLan

    NetworkPanelController {
        id: ctl
        active: win.open
    }

    // ---- small pieces ----
    component Spring: SpringAnimation {
        spring: 4
        damping: 0.45
        epsilon: 0.01
    }

    component PillButton: Rectangle {
        id: btn
        property string label
        property bool filled: true
        property bool enabledState: true
        signal clicked
        implicitHeight: 40
        implicitWidth: lbl.implicitWidth + 32
        radius: height / 2
        color: filled ? M3.primary : M3.primaryContainer
        opacity: enabledState ? 1 : 0.38
        scale: ma.pressed ? 0.94 : 1
        Behavior on scale {
            Spring {}
        }
        TextBox {
            id: lbl
            anchors.centerIn: parent
            text: btn.label
            font.weight: Font.DemiBold
            color: btn.filled ? M3.onPrimary : M3.primary
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            enabled: btn.enabledState
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.clicked()
        }
    }

    component Chip: Rectangle {
        property string label
        property string value
        implicitHeight: 52
        implicitWidth: chipCol.implicitWidth + 28
        radius: 16
        color: M3.surfaceHigh
        Column {
            id: chipCol
            anchors.centerIn: parent
            spacing: 2
            TextBox {
                text: label
                color: M3.onVariant
                font.pixelSize: 11
            }
            TextBox {
                text: value
                font.weight: Font.DemiBold
            }
        }
    }

    component Switch: Rectangle {
        id: sw
        property bool checked: false
        signal toggled(bool value)
        implicitWidth: 52
        implicitHeight: 32
        radius: 16
        color: checked ? M3.primary : M3.surfaceHigh
        border {
            width: checked ? 0 : 2
            color: M3.outline
        }
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        Rectangle {
            property real d: sma.pressed ? 28 : (sw.checked ? 24 : 16)
            width: d
            height: d
            radius: d / 2
            anchors.verticalCenter: parent.verticalCenter
            x: sw.checked ? sw.width - width - 4 : 6
            color: sw.checked ? M3.onPrimary : M3.onVariant
            Behavior on x {
                Spring {}
            }
            Behavior on d {
                Spring {}
            }
        }
        MouseArea {
            id: sma
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: sw.toggled(!sw.checked)
        }
    }

    component NetRow: Item {
        id: row
        required property var ctl
        required property var net

        readonly property bool secured: net.security !== WifiSecurityType.Open
        readonly property bool open: ctl.selected === net.name
        readonly property bool needsPsk: secured && !net.known && !net.connected
        property string error: ""

        implicitHeight: rc.implicitHeight + 24
        Behavior on implicitHeight {
            Spring {}
        }
        clip: true

        onOpenChanged: {
            if (open && needsPsk)
                Qt.callLater(() => pw.forceActiveFocus());
            if (!open) {
                pw.text = "";
                error = "";
            }
        }

        Connections {
            target: row.net
            ignoreUnknownSignals: true
            function onConnectionFailed(reason) {
                row.error = "Couldn't connect. Check password.";
            }
        }

        Rectangle {
            width: parent.width
            height: rc.implicitHeight + 24
            radius: row.open ? 24 : 20
            Behavior on radius {
                Spring {}
            }
            color: row.net.connected ? M3.primaryContainer : row.open ? M3.surfaceHigh : "transparent"

            ColumnLayout {
                id: rc
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: 12
                }
                spacing: 10

                RowLayout {
                    spacing: 12
                    WifiIcon {
                        tier: row.ctl.tier(row.net.signalStrength)
                        iconHeight: 20
                        iconColor: row.net.connected ? M3.primary : M3.onSurface
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        TextBox {
                            text: row.net.name
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        TextBox {
                            color: M3.onVariant
                            font.pixelSize: 11
                            text: row.net.stateChanging ? "Connecting…" : row.net.connected ? "Connected" : row.net.known ? "Saved" : row.secured ? "Secured" : "Open"
                        }
                    }
                    TextBox {
                        text: Math.round(row.net.signalStrength * 100) + "%"
                        color: M3.onVariant
                    }
                }

                ColumnLayout {
                    visible: row.open
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        visible: row.needsPsk
                        Layout.fillWidth: true
                        implicitHeight: 48
                        radius: 16
                        color: M3.surface
                        border {
                            width: pw.activeFocus ? 2 : 1
                            color: pw.activeFocus ? M3.primary : M3.outline
                        }
                        RowLayout {
                            anchors {
                                fill: parent
                                leftMargin: 14
                                rightMargin: 12
                            }
                            TextInput {
                                id: pw
                                Layout.fillWidth: true
                                echoMode: show.reveal ? TextInput.Normal : TextInput.Password
                                color: M3.onSurface
                                font.pixelSize: 14
                                selectByMouse: true
                                clip: true
                                onAccepted: if (go.enabledState)
                                    go.clicked()
                                Text {
                                    visible: !pw.text && !pw.activeFocus
                                    text: "Password"
                                    color: M3.onVariant
                                    font: pw.font
                                }
                            }
                            TextBox {
                                id: show
                                property bool reveal: false
                                text: reveal ? "Hide" : "Show"
                                color: M3.primary
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: show.reveal = !show.reveal
                                }
                            }
                        }
                    }

                    TextBox {
                        visible: row.error !== ""
                        text: row.error
                        color: M3.error
                        font.pixelSize: 12
                    }

                    RowLayout {
                        spacing: 8
                        Item {
                            Layout.fillWidth: true
                        }
                        PillButton {
                            visible: row.net.known
                            filled: false
                            label: "Forget"
                            onClicked: row.ctl.forget(row.net)
                        }
                        PillButton {
                            id: go
                            label: row.net.connected ? "Disconnect" : "Connect"
                            enabledState: !(row.needsPsk && pw.text.length < 8) && !row.net.stateChanging
                            onClicked: {
                                row.error = "";
                                if (row.net.connected)
                                    row.ctl.disconnectFrom(row.net);
                                else
                                    row.ctl.connectTo(row.net, row.needsPsk ? pw.text : "");
                            }
                        }
                    }
                }
            }

            MouseArea {
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                height: 48
                cursorShape: Qt.PointingHandCursor
                onClicked: row.ctl.toggleSelected(row.net.name)
            }
        }
    }

    // ---- layout ----
    Rectangle {
        id: card
        anchors.fill: parent
        implicitHeight: body.implicitHeight + 24
        radius: 28
        color: M3.surface
        border {
            color: M3.outline
            width: 1
        }
        focus: true
        Keys.onEscapePressed: win.open = false

        ColumnLayout {
            id: body
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 10

            // hero
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: hero.implicitHeight + 28
                radius: 28
                color: win.isDisconnected ? M3.surfaceHigh : M3.primaryContainer

                ColumnLayout {
                    id: hero
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 14
                    }
                    spacing: 12

                    RowLayout {
                        spacing: 14
                        Rectangle {
                            implicitWidth: 56
                            implicitHeight: 56
                            radius: win.isLan ? 18 : 28
                            Behavior on radius {
                                Spring {}
                            }
                            color: win.isDisconnected ? M3.surfaceHigh : M3.primary
                            SignalWifiOff {
                                anchors.centerIn: parent
                                visible: win.isDisconnected
                                iconHeight: 28
                                iconColor: M3.onVariant
                            }
                            WifiIcon {
                                anchors.centerIn: parent
                                visible: win.isWifi
                                tier: ctl.tier(NetworkService.signalStrength / 100)
                                iconHeight: 28
                                iconColor: M3.onPrimary
                            }
                            LanConnectedIcon {
                                anchors.centerIn: parent
                                visible: win.isLan
                                iconHeight: 28
                                iconColor: M3.onPrimary
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            TextBox {
                                text: win.isWifi ? NetworkService.ssid : win.isLan ? "Wired connection" : "Not connected"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            TextBox {
                                text: win.isDisconnected ? "Choose a network below" : NetworkService.connectedStatus
                                color: M3.onVariant
                            }
                        }
                        Switch {
                            visible: ctl.wifiDevice !== null
                            checked: ctl.wifiEnabled
                            onToggled: v => ctl.setWifiEnabled(v)
                        }
                    }

                    Flow {
                        Layout.fillWidth: true
                        spacing: 8
                        visible: !win.isDisconnected
                        Chip {
                            label: "Interface"
                            value: NetworkService.activeInterface
                        }
                        Chip {
                            label: "Type"
                            value: NetworkService.networkType
                        }
                        Chip {
                            visible: win.isWifi
                            label: "Signal"
                            value: NetworkService.signalStrength + "%"
                        }
                    }

                    Rectangle {
                        visible: win.isWifi
                        Layout.fillWidth: true
                        implicitHeight: 8
                        radius: 4
                        color: Qt.alpha(M3.primary, 0.25)
                        Rectangle {
                            height: parent.height
                            radius: 4
                            width: parent.width * NetworkService.signalStrength / 100
                            color: M3.primary
                            Behavior on width {
                                Spring {}
                            }
                        }
                    }
                }
            }

            // list
            TextBox {
                visible: ctl.wifiDevice !== null && ctl.wifiEnabled
                text: "Available networks"
                color: M3.onVariant
                font.weight: Font.DemiBold
                Layout.leftMargin: 8
            }

            Flickable {
                visible: ctl.wifiDevice !== null && ctl.wifiEnabled
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, 320)
                contentHeight: list.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: list
                    width: parent.width
                    spacing: 4
                    Repeater {
                        model: ctl.networks
                        delegate: NetRow {
                            required property var modelData
                            Layout.fillWidth: true
                            ctl: ctl
                            net: modelData
                        }
                    }
                }
            }
        }
    }
}

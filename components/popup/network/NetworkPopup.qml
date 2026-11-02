// Material 3 Expressive network popup.
//
// Presentation-only: all networking logic lives in `NetworkService`.
// The popup is opened/closed by its host (`modules/Network.qml`) via `open`.
//
// Why this is built the way it is (the old version glitched: panel visible
// but unclickable, text stretched as if mid-reload):
//
//  1. The xdg_popup NEVER changes size while mapped. Every size change on a
//     PopupWindow is a reposition request to the compositor; animating the
//     content height (row expand, list changes) meant dozens per second,
//     which left a stale/stretched buffer and dropped the popup grab (=> no
//     input). The window is now a constant-size transparent canvas and only
//     the card inside it animates.
//  2. The window is anchored to a *snapshot* of the bar item's position taken
//     when it opens, instead of `anchor.item`, which re-anchors (reposition)
//     every time the bar item's geometry changes, e.g. when an icon changes
//     state and the bar re-lays out.
//  3. The input region is masked to the card, so the transparent remainder of
//     the window doesn't swallow clicks.
//  4. Detail tiles use stable delegates (model: 4) instead of a JS-array
//     model. A JS array model rebuilds every delegate whenever the binding
//     re-evaluates (signal dBm ticks, etc.), collapsing the layout for a frame.
import Quickshell
import Quickshell.Wayland
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.icons
import qs.services
import qs.components.popup.network

PanelWindow {
    id: popup

    // ---- Host API (unchanged) ----
    property Item anchorItem: null
    property bool open: false

    readonly property int cardWidth: 384
    property real cardX: 0
    property real cardY: 0

    // Snapshot the bar item's position once, at open time.
    function placeAtAnchor() {
        if (!anchorItem)
            return;
        const win = anchorItem.QsWindow.window;
        if (!win)
            return;
        screen = win.screen;
        const p = anchorItem.mapToItem(null, 0, 0);
        cardX = p.x + anchorItem.width / 2 - cardWidth / 2;
        cardY = p.y + anchorItem.height + 12;
    }

    onOpenChanged: {
        if (open) {
            placeAtAnchor();
            enterAnim.restart();
        }
        NetworkService.scanning = open && NetworkService.wifiAvailable;
    }

    visible: open
    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "network-popup"
    // Exclusive while open so typing always reaches the password field.
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // Click anywhere outside the card to dismiss.
    MouseArea {
        anchors.fill: parent
        onClicked: popup.open = false
    }

    // ------------------------------------------------------------------
    // Derived state
    // ------------------------------------------------------------------
    readonly property bool isWifi: NetworkService.isWifi
    readonly property bool isWired: NetworkService.isWired
    readonly property bool connected: NetworkService.connected
    readonly property bool disconnected: NetworkService.disconnected
    readonly property bool wifiAvailable: NetworkService.wifiAvailable
    readonly property bool wifiEnabled: NetworkService.wifiEnabled
    readonly property bool wifiHardwareEnabled: NetworkService.wifiHardwareEnabled
    readonly property bool scanning: NetworkService.scanning
    readonly property int networkCount: NetworkService.networkCount

    // Connection detail tiles. Only entries with real data are emitted, so
    // unknown values are never shown as misleading placeholders. The grid
    // renders these through fixed delegates (see Repeater below), so a new
    // array here only updates text — it never rebuilds the layout.
    readonly property var detailTiles: {
        const s = NetworkService;
        const tiles = [];
        if (s.activeInterface)
            tiles.push({
                label: "Interface",
                value: s.activeInterface
            });
        if (s.isWifi && s.signalStrength > 0)
            tiles.push({
                label: "Signal",
                value: s.signalStrength + "%" + (s.signalDbm ? " · " + s.signalDbm : "")
            });
        if (s.isWifi && s.band)
            tiles.push({
                label: "Band",
                value: s.band
            });
        if (s.isWifi && s.frequencyMHz > 0)
            tiles.push({
                label: "Frequency",
                value: s.frequencyMHz + " MHz · " + s.frequencyGHz + " GHz"
            });
        if (s.linkSpeed)
            tiles.push({
                label: "Link speed",
                value: s.linkSpeed
            });
        if (s.security)
            tiles.push({
                label: "Security",
                value: s.security
            });
        if (s.ipAddress)
            tiles.push({
                label: "IP address",
                value: s.ipAddress
            });
        if (s.gateway)
            tiles.push({
                label: "Gateway",
                value: s.gateway
            });
        if (s.dns)
            tiles.push({
                label: "DNS",
                value: s.dns
            });
        if (s.macAddress)
            tiles.push({
                label: "MAC address",
                value: s.macAddress
            });
        return tiles;
    }

    // ==================================================================
    // Reusable pieces
    // ==================================================================

    // Icon-only round button. Icons placed inside should anchor to center
    // (e.g. `anchors.centerIn: parent`); the button's own MouseArea is added
    // last so it always sits on top.
    component IconButton: Rectangle {
        id: ib
        default property alias iconContent: holder.data
        property bool enabledButton: true
        signal clicked

        implicitWidth: 36
        implicitHeight: 36
        radius: width / 2
        color: ma.containsMouse && enabledButton ? NetworkTheme.surfaceContainerHighest : "transparent"
        Behavior on color {
            ColorAnimation {
                duration: NetworkTheme.motionFast
            }
        }

        Item {
            id: holder
            anchors.fill: parent
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            enabled: ib.enabledButton
            onClicked: ib.clicked()
        }
    }

    // Text using the configured proportional font (Google Sans per
    // config.json), same source as the bar's TextBox.
    component PopupText: Text {
        font.family: NetworkTheme.fontFamily
    }

    // Arc spinner used while scanning / connecting. A rotating 270° arc
    // reads much better than spinning a non-symmetric icon glyph.
    component Spinner: Canvas {
        id: sp
        property color spinColor: NetworkTheme.primary
        property real spinWidth: 2

        onSpinColorChanged: requestPaint()
        onWidthChanged: requestPaint()
        onPaint: {
            const ctx = sp.getContext("2d");
            ctx.reset();
            ctx.strokeStyle = String(sp.spinColor);
            ctx.lineWidth = sp.spinWidth;
            ctx.lineCap = "round";
            ctx.beginPath();
            ctx.arc(sp.width / 2, sp.height / 2, Math.min(sp.width, sp.height) / 2 - sp.spinWidth, 0, Math.PI * 1.5);
            ctx.stroke();
        }

        RotationAnimation on rotation {
            running: sp.visible
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 900
        }
    }

    // M3 switch.
    component ToggleSwitch: Item {
        id: sw
        property bool checked: false
        property bool enabledButton: true
        signal toggled(bool value)

        implicitWidth: 50
        implicitHeight: 30
        opacity: enabledButton ? 1 : 0.5

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: sw.checked ? NetworkTheme.primaryContainerStrong : NetworkTheme.surfaceContainerHighest
            border.width: sw.checked ? 0 : 1
            border.color: NetworkTheme.outline
            Behavior on color {
                ColorAnimation {
                    duration: NetworkTheme.motionFast
                }
            }

            Rectangle {
                width: sw.checked ? 22 : 14
                height: width
                radius: width / 2
                y: (parent.height - height) / 2
                x: sw.checked ? parent.width - width - 4 : 8
                color: sw.checked ? NetworkTheme.primary : Colors.textMuted
                Behavior on x {
                    NumberAnimation {
                        duration: NetworkTheme.motionFast
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        duration: NetworkTheme.motionFast
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            enabled: sw.enabledButton
            onClicked: sw.toggled(!sw.checked)
        }
    }

    // Pill action button.
    component PillButton: Rectangle {
        id: pb
        property string label
        property bool filled: true
        property bool danger: false
        property bool enabledButton: true
        property bool loading: false
        signal clicked

        implicitHeight: 38
        implicitWidth: pbLabel.implicitWidth + 32
        radius: height / 2
        color: !enabledButton ? NetworkTheme.surfaceContainerHighest : danger ? NetworkTheme.errorContainer : filled ? NetworkTheme.primaryContainerStrong : "transparent"
        border.width: filled ? 0 : 1
        border.color: danger ? NetworkTheme.error : NetworkTheme.outline
        opacity: enabledButton ? 1 : 0.5
        Behavior on color {
            ColorAnimation {
                duration: NetworkTheme.motionFast
            }
        }

        PopupText {
            id: pbLabel
            anchors.centerIn: parent
            text: pb.label
            color: pb.danger ? NetworkTheme.error : pb.filled ? NetworkTheme.primary : Colors.text
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            enabled: pb.enabledButton && !pb.loading
            onClicked: pb.clicked()
        }
    }

    // Label/value tile used in the connection details grid.
    component DetailTile: Rectangle {
        id: tile
        property string label
        property string value
        Layout.fillWidth: true
        implicitHeight: 50
        radius: NetworkTheme.radiusSmall
        color: NetworkTheme.surfaceContainerHigh

        Column {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 12
            }
            spacing: 2

            PopupText {
                width: parent.width
                text: tile.label
                color: Colors.text
                font.pixelSize: 11
                font.weight: Font.Medium
                elide: Text.ElideRight
            }
            PopupText {
                width: parent.width
                text: tile.value
                color: Colors.textMuted
                font.pixelSize: 13
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }
        }
    }

    // ==================================================================
    // Network row
    // ==================================================================
    component NetRow: Item {
        id: row
        required property var net

        readonly property bool secured: net.security !== WifiSecurityType.Open
        readonly property bool isConnected: net.connected
        readonly property bool known: net.known
        readonly property bool connecting: busy || net.stateChanging
        readonly property int signalPercent: Math.round(net.signalStrength * 100)
        readonly property bool needsPassword: secured && !known && !isConnected

        readonly property string statusText: {
            if (isConnected)
                return "Connected";
            if (connecting)
                return "Connecting…";
            if (known)
                return "Saved";
            if (secured)
                return "Secured";
            return "Open";
        }

        property bool expanded: false
        property bool busy: false
        property bool justConnected: false
        property string errorText: ""
        property string password: ""
        property bool revealPassword: false

        implicitHeight: rowContent.implicitHeight
        clip: true

        onExpandedChanged: {
            if (!expanded) {
                passwordField.text = "";
                password = "";
                errorText = "";
                revealPassword = false;
            } else if (needsPassword) {
                Qt.callLater(() => passwordField.forceActiveFocus());
            }
        }

        Connections {
            target: row.net
            ignoreUnknownSignals: true

            function onConnectionFailed(reason) {
                row.busy = false;
                row.errorText = NetworkService.connectionFailureMessage(reason);
                row.expanded = true;
            }

            function onConnectedChanged() {
                if (row.net.connected) {
                    row.busy = false;
                    row.errorText = "";
                    row.justConnected = true;
                    successTimer.restart();
                }
            }
        }

        Timer {
            id: successTimer
            interval: 1800
            onTriggered: row.justConnected = false
        }

        Timer {
            id: timeoutTimer
            interval: 20000
            onTriggered: {
                if (row.busy) {
                    row.busy = false;
                    row.errorText = "Connection timed out.";
                }
            }
        }

        Rectangle {
            id: bg
            anchors.fill: parent
            radius: row.expanded ? NetworkTheme.radiusLarge : NetworkTheme.radiusMedium
            color: row.isConnected ? NetworkTheme.primaryContainer : row.expanded ? NetworkTheme.surfaceContainerHigh : "transparent"
            border.width: row.expanded && !row.isConnected ? 1 : 0
            border.color: NetworkTheme.outlineVariant
            Behavior on radius {
                NumberAnimation {
                    duration: NetworkTheme.motionMedium
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: NetworkTheme.motionMedium
                }
            }
        }

        Column {
            id: rowContent
            width: parent.width

            // ---- header ----
            Item {
                id: header
                width: parent.width
                height: 62

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 12
                        rightMargin: 12
                    }
                    spacing: 12

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 14
                        color: row.isConnected ? NetworkTheme.primaryContainerStrong : NetworkTheme.surfaceContainerHighest

                        WifiIcon {
                            anchors.centerIn: parent
                            tier: NetworkService.tier(row.net.signalStrength)
                            iconHeight: 22
                            iconColor: row.isConnected ? NetworkTheme.primary : Colors.textMuted
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            PopupText {
                                Layout.fillWidth: true
                                text: row.net.name
                                color: Colors.text
                                font.pixelSize: 14
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                            }
                            LockIcon {
                                visible: row.secured
                                iconSize: 13
                                iconColor: Colors.textMuted
                            }
                        }

                        PopupText {
                            text: row.statusText
                            color: row.isConnected ? NetworkTheme.onPrimaryContainer : Colors.textMuted
                            font.pixelSize: 11
                        }
                    }

                    PopupText {
                        visible: row.justConnected
                        text: "Connected"
                        color: Colors.success
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                    }

                    PopupText {
                        visible: !row.justConnected && !row.connecting
                        text: row.signalPercent + "%"
                        color: Colors.textMuted
                        font.pixelSize: 12
                    }

                    Spinner {
                        visible: !row.justConnected && row.connecting
                        width: 14
                        height: 14
                        spinWidth: 2
                    }

                    ExpandMoreIcon {
                        iconSize: 18
                        iconColor: Colors.textMuted
                        rotation: row.expanded ? 180 : 0
                        Behavior on rotation {
                            NumberAnimation {
                                duration: NetworkTheme.motionMedium
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: row.expanded = !row.expanded
                }
            }

            // ---- expanded actions ----
            ColumnLayout {
                id: details
                width: parent.width
                height: row.expanded ? implicitHeight : 0
                opacity: row.expanded ? 1 : 0
                clip: true
                spacing: 10
                Behavior on height {
                    NumberAnimation {
                        duration: NetworkTheme.motionMedium
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: NetworkTheme.motionFast
                    }
                }

                // password field
                Rectangle {
                    visible: row.needsPassword
                    Layout.fillWidth: true
                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                    implicitHeight: 46
                    radius: NetworkTheme.radiusSmall
                    color: NetworkTheme.surface
                    border.width: passwordField.activeFocus ? 2 : 1
                    border.color: row.errorText !== "" ? NetworkTheme.error : passwordField.activeFocus ? NetworkTheme.primary : NetworkTheme.outline

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 14
                            rightMargin: 8
                        }
                        spacing: 6

                        TextInput {
                            id: passwordField
                            Layout.fillWidth: true
                            echoMode: row.revealPassword ? TextInput.Normal : TextInput.Password
                            color: Colors.text
                            font.pixelSize: 14
                            font.family: NetworkTheme.fontFamily
                            selectByMouse: true
                            clip: true
                            passwordCharacter: "•"
                            // The connect button's enabled state reads
                            // `row.password`, so the field has to sync into
                            // it — without this the button never enables.
                            onTextChanged: row.password = text
                            onAccepted: if (connectButton.enabledButton)
                                connectButton.clicked()

                            PopupText {
                                anchors.verticalCenter: parent.verticalCenter
                                visible: !passwordField.text && !passwordField.activeFocus
                                text: "Password"
                                color: Colors.textFaint
                                font: passwordField.font
                            }
                        }

                        IconButton {
                            implicitWidth: 32
                            implicitHeight: 32
                            onClicked: row.revealPassword = !row.revealPassword

                            EyeIcon {
                                anchors.centerIn: parent
                                visible: !row.revealPassword
                                iconSize: 18
                                iconColor: Colors.textMuted
                            }
                            EyeOffIcon {
                                anchors.centerIn: parent
                                visible: row.revealPassword
                                iconSize: 18
                                iconColor: Colors.textMuted
                            }
                        }
                    }
                }

                // error message
                RowLayout {
                    visible: row.errorText !== ""
                    Layout.fillWidth: true
                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                    spacing: 6

                    ErrorIcon {
                        iconSize: 15
                        iconColor: NetworkTheme.error
                    }
                    PopupText {
                        Layout.fillWidth: true
                        text: row.errorText
                        color: NetworkTheme.error
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                    }
                }

                // action buttons
                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                    Layout.bottomMargin: 12
                    spacing: 8

                    Item {
                        Layout.fillWidth: true
                    }

                    PillButton {
                        visible: row.known
                        filled: false
                        danger: true
                        label: "Forget"
                        onClicked: NetworkService.forget(row.net)
                    }

                    PillButton {
                        id: connectButton
                        filled: true
                        label: row.isConnected ? "Disconnect" : row.connecting ? "Connecting…" : "Connect"
                        enabledButton: !row.connecting && (!row.needsPassword || row.password.length >= 8)
                        onClicked: {
                            row.errorText = "";
                            if (row.isConnected) {
                                NetworkService.disconnectFrom(row.net);
                            } else {
                                row.busy = true;
                                timeoutTimer.restart();
                                NetworkService.connectTo(row.net, row.needsPassword ? row.password : "");
                            }
                        }
                    }
                }
            }
        }
    }

    // ==================================================================
    // Card
    // ==================================================================
    // The window is a fixed-size transparent canvas; the card sizes itself
    // to its content and animates *inside* it, so the compositor never sees
    // a resize while the popup is mapped.
    Rectangle {
        id: card

        // 0 -> 1 on open (fade + small slide), driven by enterAnim.
        property real enter: 1

        x: Math.max(8, Math.min(popup.width - width - 8, popup.cardX))
        y: popup.cardY
        width: popup.cardWidth
        height: Math.min(popup.height - y - 8, cardContent.implicitHeight + 32)
        Behavior on height {
            enabled: popup.visible
            NumberAnimation {
                duration: NetworkTheme.motionMedium
                easing.type: Easing.OutCubic
            }
        }

        opacity: enter
        transform: Translate {
            y: (1 - card.enter) * -10
        }
        NumberAnimation {
            id: enterAnim
            target: card
            property: "enter"
            from: 0
            to: 1
            duration: NetworkTheme.motionMedium
            easing.type: Easing.OutCubic
        }

        radius: NetworkTheme.radiusLarge
        color: NetworkTheme.surface
        border.width: 1
        border.color: NetworkTheme.outline
        clip: true
        focus: true

        Keys.onEscapePressed: popup.open = false
        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            id: cardContent
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 16
            }
            spacing: 12

            // ---- header ----
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                PopupText {
                    text: "Network"
                    color: Colors.text
                    font.pixelSize: 18
                    font.weight: Font.Bold
                }

                Item {
                    Layout.fillWidth: true
                }

                IconButton {
                    visible: popup.wifiAvailable
                    enabledButton: popup.wifiEnabled
                    onClicked: NetworkService.rescan()

                    RefreshIcon {
                        anchors.centerIn: parent
                        visible: !popup.scanning
                        iconSize: 19
                        iconColor: popup.wifiEnabled ? Colors.textMuted : Colors.textFaint
                    }

                    Spinner {
                        anchors.centerIn: parent
                        visible: popup.scanning
                        width: 20
                        height: 20
                        spinWidth: 2
                    }
                }

                ToggleSwitch {
                    visible: popup.wifiAvailable
                    checked: popup.wifiEnabled
                    onToggled: value => NetworkService.setWifiEnabled(value)
                }
            }

            // ---- hero ----
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: hero.implicitHeight + 28
                radius: NetworkTheme.radiusLarge
                color: popup.connected ? NetworkTheme.primaryContainer : NetworkTheme.surfaceContainerHigh
                Behavior on color {
                    ColorAnimation {
                        duration: NetworkTheme.motionMedium
                    }
                }

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
                        Layout.fillWidth: true
                        spacing: 14

                        Rectangle {
                            Layout.preferredWidth: 52
                            Layout.preferredHeight: 52
                            radius: popup.isWired ? 18 : 26
                            color: popup.connected ? NetworkTheme.primaryContainerStrong : NetworkTheme.surfaceContainerHighest
                            Behavior on radius {
                                NumberAnimation {
                                    duration: NetworkTheme.motionMedium
                                    easing.type: Easing.OutCubic
                                }
                            }

                            SignalWifiOff {
                                anchors.centerIn: parent
                                visible: popup.disconnected
                                iconHeight: 26
                                iconColor: Colors.textMuted
                            }
                            WifiIcon {
                                anchors.centerIn: parent
                                visible: popup.isWifi
                                tier: NetworkService.tier(NetworkService.signalFraction)
                                iconHeight: 26
                                iconColor: NetworkTheme.primary
                            }
                            LanConnectedIcon {
                                anchors.centerIn: parent
                                visible: popup.isWired
                                iconHeight: 26
                                iconColor: NetworkTheme.primary
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            PopupText {
                                Layout.fillWidth: true
                                text: popup.isWifi ? (NetworkService.ssid || "Wi-Fi") : popup.isWired ? "Wired connection" : "Not connected"
                                color: Colors.text
                                font.pixelSize: 17
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                            }
                            PopupText {
                                text: popup.disconnected ? "Choose a network below" : NetworkService.connectedStatus
                                color: Colors.textMuted
                                font.pixelSize: 12
                            }
                        }
                    }

                    // signal bar (wifi only)
                    Rectangle {
                        visible: popup.isWifi && popup.connected
                        Layout.fillWidth: true
                        implicitHeight: 8
                        radius: 4
                        color: Qt.alpha(NetworkTheme.primary, 0.22)

                        Rectangle {
                            height: parent.height
                            radius: 4
                            width: parent.width * Math.max(0, Math.min(1, NetworkService.signalFraction))
                            color: NetworkTheme.primary
                            Behavior on width {
                                NumberAnimation {
                                    duration: NetworkTheme.motionMedium
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }
                }
            }

            // ---- connection details ----
            PopupText {
                visible: popup.connected && popup.detailTiles.length > 0
                text: "Connection details"
                color: Colors.textMuted
                font.pixelSize: 12
                font.weight: Font.DemiBold
            }

            GridLayout {
                visible: popup.connected && popup.detailTiles.length > 0
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 8
                rowSpacing: 8

                // Four stable delegates; an index past the data is simply
                // hidden (GridLayout skips invisible items). Value updates
                // change text in place — nothing is destroyed/recreated.
                Repeater {
                    model: 4

                    delegate: DetailTile {
                        required property int index
                        readonly property var entry: index < popup.detailTiles.length ? popup.detailTiles[index] : null
                        visible: entry !== null
                        label: entry ? entry.label : ""
                        value: entry ? entry.value : ""
                    }
                }
            }

            // ---- network list section ----
            RowLayout {
                visible: popup.wifiAvailable
                Layout.fillWidth: true
                spacing: 6

                PopupText {
                    Layout.fillWidth: true
                    text: "Available networks"
                    color: Colors.textMuted
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                }

                PopupText {
                    visible: popup.wifiEnabled && !popup.scanning
                    text: popup.networkCount + (popup.networkCount === 1 ? " network" : " networks")
                    color: Colors.textFaint
                    font.pixelSize: 11
                }

                PopupText {
                    visible: popup.wifiEnabled && popup.scanning
                    text: "Scanning…"
                    color: Colors.textFaint
                    font.pixelSize: 11
                }
            }

            // no wifi hardware
            Rectangle {
                visible: !popup.wifiAvailable
                Layout.fillWidth: true
                implicitHeight: 64
                radius: NetworkTheme.radiusMedium
                color: NetworkTheme.surfaceContainerHigh

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 14
                        rightMargin: 14
                    }
                    spacing: 10

                    InfoIcon {
                        iconSize: 18
                        iconColor: Colors.textMuted
                    }
                    PopupText {
                        Layout.fillWidth: true
                        text: "No Wi-Fi adapter detected."
                        color: Colors.textMuted
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                    }
                }
            }

            // wifi off
            Rectangle {
                visible: popup.wifiAvailable && !popup.wifiHardwareEnabled
                Layout.fillWidth: true
                implicitHeight: 64
                radius: NetworkTheme.radiusMedium
                color: NetworkTheme.errorContainer

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 14
                        rightMargin: 14
                    }
                    spacing: 10

                    ErrorIcon {
                        iconSize: 18
                        iconColor: NetworkTheme.error
                    }
                    PopupText {
                        Layout.fillWidth: true
                        text: "Wi-Fi is disabled in hardware (rfkill)."
                        color: NetworkTheme.error
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                visible: popup.wifiAvailable && popup.wifiHardwareEnabled && !popup.wifiEnabled
                Layout.fillWidth: true
                implicitHeight: 96
                radius: NetworkTheme.radiusMedium
                color: NetworkTheme.surfaceContainerHigh

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    PowerIcon {
                        Layout.alignment: Qt.AlignHCenter
                        iconSize: 22
                        iconColor: Colors.textMuted
                    }
                    PopupText {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Wi-Fi is off"
                        color: Colors.text
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }
                    PillButton {
                        Layout.alignment: Qt.AlignHCenter
                        label: "Turn on"
                        onClicked: NetworkService.setWifiEnabled(true)
                    }
                }
            }

            // scanning / empty states
            Rectangle {
                visible: popup.wifiAvailable && popup.wifiEnabled && popup.networkCount === 0
                Layout.fillWidth: true
                implicitHeight: 96
                radius: NetworkTheme.radiusMedium
                color: NetworkTheme.surfaceContainerHigh

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    RefreshIcon {
                        Layout.alignment: Qt.AlignHCenter
                        visible: !popup.scanning
                        iconSize: 22
                        iconColor: Colors.textMuted
                    }
                    Spinner {
                        Layout.alignment: Qt.AlignHCenter
                        visible: popup.scanning
                        width: 22
                        height: 22
                        spinWidth: 2
                    }
                    PopupText {
                        Layout.alignment: Qt.AlignHCenter
                        text: popup.scanning ? "Scanning for networks…" : "No networks found"
                        color: Colors.textMuted
                        font.pixelSize: 12
                    }
                    PillButton {
                        visible: !popup.scanning
                        Layout.alignment: Qt.AlignHCenter
                        filled: false
                        label: "Scan again"
                        onClicked: NetworkService.rescan()
                    }
                }
            }

            // network list
            Flickable {
                id: listFlick
                visible: popup.wifiAvailable && popup.wifiEnabled && popup.networkCount > 0
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, 300)
                contentHeight: listColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: listColumn
                    width: listFlick.width
                    spacing: 4

                    Repeater {
                        model: NetworkService.networks

                        delegate: NetRow {
                            required property var modelData
                            net: modelData
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }
}

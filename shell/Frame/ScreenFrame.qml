import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules.common

Scope {
    id: root

    // Runtime state. Initialized from config.json; overrides via IPC are
    // session-only and intentionally do not write back to config.json.
    property bool frameEnabled: Config.data.frame.enabled
    property real frameRadius: Config.data.frame.radius
    property real frameWidth: Config.data.frame.width
    property real frameMargin: Config.data.frame.margin
    property real frameOpacity: Config.data.frame.opacity
    property string frameColor: Config.data.frame.color

    // Same color the bar paints itself with (see shell/Bar/Bar.qml), so the
    // corner fills meld seamlessly into the bar.
    readonly property color barColor: Qt.alpha(Colors.background2, 0.7)

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: frameWindow
            required property var modelData

            screen: modelData
            color: "transparent"
            visible: root.frameEnabled

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            // The frame sits right below the bar and melds into it.
            margins {
                top: Types.stringToPosition(Config.data.bar.position) === Types.Position.Top ? Config.data.bar.size : 0
                bottom: Types.stringToPosition(Config.data.bar.position) === Types.Position.Bottom ? Config.data.bar.size : 0
            }

            // Purely decorative: reserve no space and never take input.
            exclusionMode: ExclusionMode.Ignore
            focusable: false

            // Draw above regular windows so the frame encloses the screen.
            WlrLayershell.layer: WlrLayer.Overlay

            // Empty region = fully click-through.
            mask: Region {}

            // The frame's rounded corners leave small wedges at the window
            // corners. Fill them with the bar's background color so the frame
            // melds with the bar instead of showing gaps.
            Canvas {
                id: cornerFill
                anchors.fill: parent
                opacity: root.frameOpacity

                onPaint: {
                    const ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    let r = root.frameRadius;
                    const m = root.frameMargin;
                    if (r <= 0 || width <= 0 || height <= 0)
                        return;

                    const x0 = m;
                    const y0 = m;
                    const x1 = width - m;
                    const y1 = height - m;
                    r = Math.min(r, (x1 - x0) / 2, (y1 - y0) / 2);

                    ctx.fillStyle = root.barColor;
                    ctx.beginPath();

                    // top-left
                    ctx.moveTo(x0, y0);
                    ctx.lineTo(x0 + r, y0);
                    ctx.arc(x0 + r, y0 + r, r, -Math.PI / 2, Math.PI, true);
                    ctx.closePath();

                    // top-right
                    ctx.moveTo(x1, y0);
                    ctx.lineTo(x1 - r, y0);
                    ctx.arc(x1 - r, y0 + r, r, -Math.PI / 2, 0, false);
                    ctx.closePath();

                    // bottom-right
                    ctx.moveTo(x1, y1);
                    ctx.lineTo(x1, y1 - r);
                    ctx.arc(x1 - r, y1 - r, r, 0, Math.PI / 2, false);
                    ctx.closePath();

                    // bottom-left
                    ctx.moveTo(x0, y1);
                    ctx.lineTo(x0 + r, y1);
                    ctx.arc(x0 + r, y1 - r, r, Math.PI / 2, Math.PI, false);
                    ctx.closePath();

                    ctx.fill();
                }

                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                Connections {
                    target: root
                    function onFrameRadiusChanged() { cornerFill.requestPaint(); }
                    function onFrameMarginChanged() { cornerFill.requestPaint(); }
                    function onBarColorChanged() { cornerFill.requestPaint(); }
                }
            }

            Rectangle {
                id: frameRect
                anchors.fill: parent
                anchors.margins: root.frameMargin
                radius: root.frameRadius
                color: "transparent"
                border.width: root.frameWidth
                border.color: root.frameColor !== "" ? root.frameColor : Colors.border
                opacity: root.frameOpacity
                antialiasing: true
                visible: root.frameWidth > 0
            }
        }
    }

    IpcHandler {
        target: "frame"

        function toggle(): void {
            root.frameEnabled = !root.frameEnabled
        }

        function setEnabled(enabled: bool): void {
            root.frameEnabled = enabled
        }

        function getEnabled(): bool {
            return root.frameEnabled
        }

        function setRadius(radius: int): void {
            root.frameRadius = radius
        }

        function getRadius(): int {
            return root.frameRadius
        }

        function setWidth(width: int): void {
            root.frameWidth = width
        }

        function getWidth(): int {
            return root.frameWidth
        }

        function setMargin(margin: int): void {
            root.frameMargin = margin
        }

        function getMargin(): int {
            return root.frameMargin
        }

        function setColor(color: string): void {
            root.frameColor = color
        }

        function getColor(): string {
            return root.frameColor !== "" ? root.frameColor : Colors.border
        }
    }
}

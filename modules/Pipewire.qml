import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.common
import qs.services

Item {
    id: root

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    property int iconSize: Config?.volume?.iconSize ?? 18
    property bool volumeVisible: Config?.volume?.visible ?? true
    property real volumePercent: Math.round((PipewireService.volume ?? 0) * 100)
    property bool isMuted: PipewireService.muted ?? false

    readonly property string dynamicColor: root.isMuted || volumePercent > 100 ? Colors.error : Colors.text

    component VolumeIcon: Item {
        id: iconRoot
        property int iconSize: 18
        property string iconColor: Colors.text
        property bool isMuted: false
        property real volume: 0

        width: iconSize
        height: iconSize
        implicitWidth: iconSize
        implicitHeight: iconSize

        // Select the active SVG path based on volume state
        readonly property string activePath: {
            if (iconRoot.isMuted) {
                return "M 792 -56 L 671 -177 C 654.333 -166.333 636.667 -157.167 618 -149.5 C 599.333 -141.833 580 -135.667 560 -131 L 560 -213 C 569.333 -216.333 578.5 -219.667 587.5 -223 C 596.5 -226.333 605 -230.333 613 -235 L 480 -368 L 480 -160 L 280 -360 L 120 -360 L 120 -600 L 248 -600 L 56 -792 L 112 -848 L 848 -112 L 792 -56 M 784 -288 L 726 -346 C 737.333 -366.667 745.833 -388.333 751.5 -411 C 757.167 -433.667 760 -457 760 -481 C 760 -543.667 741.667 -599.667 705 -649 C 668.333 -698.333 620 -731.667 560 -749 L 560 -831 C 642.667 -812.333 710 -770.5 762 -705.5 C 814 -640.5 840 -565.667 840 -481 C 840 -445.667 835.167 -411.667 825.5 -379 C 815.833 -346.333 802 -316 784 -288 M 650 -422 L 560 -512 L 560 -642 C 591.333 -627.333 615.833 -605.333 633.5 -576 C 651.167 -546.667 660 -514.667 660 -480 C 660 -470 659.167 -460.167 657.5 -450.5 C 655.833 -440.833 653.333 -431.333 650 -422 M 480 -592 L 376 -696 L 480 -800 L 480 -592 ";
            }
            if (iconRoot.volume <= 0) {
                return "M 280 -360 L 280 -600 L 440 -600 L 640 -800 L 640 -160 L 440 -360 L 280 -360 ";
            }
            if (iconRoot.volume < 50) {
                // Volume1 (Volume Down / Single Wave)
                return "M 200 -360 L 200 -600 L 360 -600 L 560 -800 L 560 -160 L 360 -360 L 200 -360 M 640 -320 L 640 -642 C 670 -628 694.167 -606.333 712.5 -577 C 730.833 -547.667 740 -515.333 740 -480 C 740 -444.667 730.833 -412.667 712.5 -384 C 694.167 -355.333 670 -334 640 -320 ";
            }
            // Volume2 (Volume Up / Double Waves)
            return "M 560 -131 L 560 -213 C 620 -230.333 668.333 -263.667 705 -313 C 741.667 -362.333 760 -418.333 760 -481 C 760 -543.667 741.667 -599.667 705 -649 C 668.333 -698.333 620 -731.667 560 -749 L 560 -831 C 642.667 -812.333 710 -770.5 762 -705.5 C 814 -640.5 840 -565.667 840 -481 C 840 -396.333 814 -321.5 762 -256.5 C 710 -191.5 642.667 -149.667 560 -131 M 120 -360 L 120 -600 L 280 -600 L 480 -800 L 480 -160 L 280 -360 L 120 -360 M 560 -320 L 560 -642 C 591.333 -627.333 615.833 -605.333 633.5 -576 C 651.167 -546.667 660 -514.667 660 -480 C 660 -446 651.167 -414.5 633.5 -385.5 C 615.833 -356.5 591.333 -334.667 560 -320 ";
        }

        transform: [
            Translate {
                x: 0
                y: 960
            },
            Scale {
                xScale: iconRoot.width / 960
                yScale: iconRoot.height / 960
            }
        ]

        Shape {
            anchors.fill: parent
            transformOrigin: Item.TopLeft
            ShapePath {
                strokeColor: "transparent"
                fillColor: iconRoot.iconColor
                fillRule: ShapePath.WindingFill
                PathSvg {
                    path: iconRoot.activePath
                }
            }
        }
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 4

        // Active Volume Icon
        VolumeIcon {
            visible: root.volumeVisible
            iconSize: root.iconSize
            isMuted: root.isMuted
            volume: root.volumePercent
            iconColor: root.dynamicColor
            Layout.alignment: Qt.AlignVCenter
        }

        TextBox {
            visible: root.volumeVisible
            color: root.dynamicColor
            Layout.alignment: Qt.AlignVCenter
            text: root.isMuted ? "Muted" : `${root.volumePercent}%`
        }
    }

    WrapperMouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                PipewireService.toggleMute();
            }
        }

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                PipewireService.volumeUp(0.05);
            } else {
                PipewireService.volumeDown(0.05);
            }
        }
    }
}

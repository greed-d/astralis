// qs/modules/icons/BatteryIcon.qml
import QtQuick
import QtQuick.Shapes

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    property real percent: 100   // 0-100
    property bool alert: false
    property bool charging: false
    property color color: "#e3e3e3"

    readonly property real clampedPercent: Math.max(0, Math.min(100, root.percent))
    readonly property real cavityLeft: 120
    readonly property real cavityRight: 700
    readonly property real holeLeft: root.cavityLeft + (root.clampedPercent / 100) * (root.cavityRight - root.cavityLeft)

    transform: [
        Translate {
            x: 0
            y: 960
        },
        Scale {
            xScale: width / 960
            yScale: height / 960
        }
    ]

    Shape {
        transformOrigin: Item.TopLeft
        visible: !root.alert && !root.charging

        ShapePath {
            strokeColor: "transparent"
            fillColor: root.color
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: `M 160 -240 C 126.667 -240 98.3333 -251.667 75 -275 C 51.6667 -298.333 40 -326.667 40 -360 L 40 -600 C 40 -633.333 51.6667 -661.667 75 -685 C 98.3333 -708.333 126.667 -720 160 -720 L 700 -720 C 733.333 -720 761.667 -708.333 785 -685 C 808.333 -661.667 820 -633.333 820 -600 L 820 -360 C 820 -326.667 808.333 -298.333 785 -275 C 761.667 -251.667 733.333 -240 700 -240 L 160 -240 M 860 -380 L 860 -580 L 880 -580 C 891.333 -580 900.833 -576.167 908.5 -568.5 C 916.167 -560.833 920 -551.333 920 -540 L 920 -420 C 920 -408.667 916.167 -399.167 908.5 -391.5 C 900.833 -383.833 891.333 -380 880 -380 L 860 -380 M ${root.holeLeft} -320 L 700 -320 C 711.333 -320 720.833 -323.833 728.5 -331.5 C 736.167 -339.167 740 -348.667 740 -360 L 740 -600 C 740 -611.333 736.167 -620.833 728.5 -628.5 C 720.833 -636.167 711.333 -640 700 -640 L ${root.holeLeft} -640 L ${root.holeLeft} -320 `
            }
        }
    }

    Shape {
        transformOrigin: Item.TopLeft
        visible: root.alert && !root.charging

        ShapePath {
            strokeColor: "transparent"
            fillColor: root.color
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 160 -240 C 126.667 -240 98.3333 -251.667 75 -275 C 51.6667 -298.333 40 -326.667 40 -360 L 40 -600 C 40 -633.333 51.6667 -661.667 75 -685 C 98.3333 -708.333 126.667 -720 160 -720 L 720 -720 L 720 -320 C 720 -304.667 722.833 -290.167 728.5 -276.5 C 734.167 -262.833 741.667 -250.667 751 -240 L 160 -240 M 811.5 -311.5 C 803.833 -319.167 800 -328.667 800 -340 C 800 -351.333 803.833 -360.833 811.5 -368.5 C 819.167 -376.167 828.667 -380 840 -380 C 851.333 -380 860.833 -376.167 868.5 -368.5 C 876.167 -360.833 880 -351.333 880 -340 C 880 -328.667 876.167 -319.167 868.5 -311.5 C 860.833 -303.833 851.333 -300 840 -300 C 828.667 -300 819.167 -303.833 811.5 -311.5 M 800 -440 L 800 -680 L 880 -680 L 880 -440 L 800 -440 "
            }
        }
    }

    Shape {
        transformOrigin: Item.TopLeft
        visible: root.charging

        ShapePath {
            strokeColor: "transparent"
            fillColor: root.color
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 160 -240 C 126.667 -240 98.3333 -251.667 75 -275 C 51.6667 -298.333 40 -326.667 40 -360 L 40 -600 C 40 -633.333 51.6667 -661.667 75 -685 C 98.3333 -708.333 126.667 -720 160 -720 L 722 -720 L 658 -640 L 160 -640 C 148.667 -640 139.167 -636.167 131.5 -628.5 C 123.833 -620.833 120 -611.333 120 -600 L 120 -360 C 120 -348.667 123.833 -339.167 131.5 -331.5 C 139.167 -323.833 148.667 -320 160 -320 L 633 -320 L 618 -240 L 160 -240 M 707 -280 L 735 -440 L 600 -440 L 792 -680 L 813 -680 L 785 -520 L 920 -520 L 728 -280 L 707 -280 M 160 -360 L 160 -600 L 626 -600 L 434 -360 L 160 -360 "
            }
        }
    }
}

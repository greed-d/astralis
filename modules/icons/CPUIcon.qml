// Generated from SVG file developer_board_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: __qt_toplevel

    property int iconHeight: 24
    property string iconColor: "#ffe3e3e3"
    implicitWidth: iconHeight
    implicitHeight: iconHeight
    component AnimationsInfo: QtObject {
        property bool paused: false
        property int loops: 1
        signal restart
    }
    property AnimationsInfo animations: AnimationsInfo {}
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
        id: _qt_node0
        transformOrigin: Item.TopLeft
        ShapePath {
            id: _qt_node1_fill_stroke
            strokeColor: "transparent"
            fillColor: __qt_toplevel.iconColor
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 160 -120 C 138 -120 119.167 -127.833 103.5 -143.5 C 87.8333 -159.167 80 -178 80 -200 L 80 -760 C 80 -782 87.8333 -800.833 103.5 -816.5 C 119.167 -832.167 138 -840 160 -840 L 720 -840 C 742 -840 760.833 -832.167 776.5 -816.5 C 792.167 -800.833 800 -782 800 -760 L 800 -680 L 880 -680 L 880 -600 L 800 -600 L 800 -520 L 880 -520 L 880 -440 L 800 -440 L 800 -360 L 880 -360 L 880 -280 L 800 -280 L 800 -200 C 800 -178 792.167 -159.167 776.5 -143.5 C 760.833 -127.833 742 -120 720 -120 L 160 -120 M 160 -200 L 720 -200 L 720 -760 L 160 -760 L 160 -200 M 240 -280 L 440 -280 L 440 -440 L 240 -440 L 240 -280 M 480 -560 L 640 -560 L 640 -680 L 480 -680 L 480 -560 M 240 -480 L 440 -480 L 440 -680 L 240 -680 L 240 -480 M 480 -280 L 640 -280 L 640 -520 L 480 -520 L 480 -280 M 160 -760 L 160 -200 L 160 -760 "
            }
        }
    }
}

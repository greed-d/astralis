// Generated from SVG file device_thermostat_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: __qt_toplevel
    property int iconSize: 24
    property string iconColor: "#ffe3e3e3"
    implicitWidth: iconSize
    implicitHeight: iconSize
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
            fillColor: iconColor
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 338.5 -138.5 C 299.5 -177.5 280 -224.667 280 -280 C 280 -312 287 -341.833 301 -369.5 C 315 -397.167 334.667 -420.667 360 -440 L 360 -760 C 360 -793.333 371.667 -821.667 395 -845 C 418.333 -868.333 446.667 -880 480 -880 C 513.333 -880 541.667 -868.333 565 -845 C 588.333 -821.667 600 -793.333 600 -760 L 600 -440 C 625.333 -420.667 645 -397.167 659 -369.5 C 673 -341.833 680 -312 680 -280 C 680 -224.667 660.5 -177.5 621.5 -138.5 C 582.5 -99.5 535.333 -80 480 -80 C 424.667 -80 377.5 -99.5 338.5 -138.5 M 440 -520 L 520 -520 L 520 -560 L 480 -560 L 480 -600 L 520 -600 L 520 -680 L 480 -680 L 480 -720 L 520 -720 L 520 -760 C 520 -771.333 516.167 -780.833 508.5 -788.5 C 500.833 -796.167 491.333 -800 480 -800 C 468.667 -800 459.167 -796.167 451.5 -788.5 C 443.833 -780.833 440 -771.333 440 -760 L 440 -520 "
            }
        }
    }
}

// Generated from SVG file thermometer_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
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
                path: "M 480 -120 C 424.667 -120 377.5 -139.5 338.5 -178.5 C 299.5 -217.5 280 -264.667 280 -320 C 280 -352 287 -381.833 301 -409.5 C 315 -437.167 334.667 -460.667 360 -480 L 360 -720 C 360 -753.333 371.667 -781.667 395 -805 C 418.333 -828.333 446.667 -840 480 -840 C 513.333 -840 541.667 -828.333 565 -805 C 588.333 -781.667 600 -753.333 600 -720 L 600 -480 C 625.333 -460.667 645 -437.167 659 -409.5 C 673 -381.833 680 -352 680 -320 C 680 -264.667 660.5 -217.5 621.5 -178.5 C 582.5 -139.5 535.333 -120 480 -120 M 440 -560 L 520 -560 L 520 -720 C 520 -731.333 516.167 -740.833 508.5 -748.5 C 500.833 -756.167 491.333 -760 480 -760 C 468.667 -760 459.167 -756.167 451.5 -748.5 C 443.833 -740.833 440 -731.333 440 -720 L 440 -560 "
            }
        }
    }
}

// Generated from SVG file network_wifi_1_bar_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: __qt_toplevel
    property var iconHeight: 24
    property var iconColor: "#ffe3e3e3"
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
            fillColor: iconColor
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 480 -120 L 0 -600 C 64 -665.333 137.333 -715 220 -749 C 302.667 -783 389.333 -800 480 -800 C 571.333 -800 658.333 -783 741 -749 C 823.667 -715 896.667 -665.333 960 -600 L 480 -120 M 361 -353 C 377.667 -365 396.167 -374.333 416.5 -381 C 436.833 -387.667 458 -391 480 -391 C 502 -391 523.167 -387.667 543.5 -381 C 563.833 -374.333 582.333 -365 599 -353 L 844 -598 C 792 -637.333 735.167 -667.5 673.5 -688.5 C 611.833 -709.5 547.333 -720 480 -720 C 412.667 -720 348.167 -709.5 286.5 -688.5 C 224.833 -667.5 168 -637.333 116 -598 L 361 -353 "
            }
        }
    }
}

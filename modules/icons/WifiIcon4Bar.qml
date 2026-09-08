// Generated from SVG file signal_wifi_4_bar_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
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
                path: "M 480 -120 L 0 -600 C 63.3333 -664.667 136.5 -714.167 219.5 -748.5 C 302.5 -782.833 389.333 -800 480 -800 C 570.667 -800 657.5 -782.833 740.5 -748.5 C 823.5 -714.167 896.667 -664.667 960 -600 L 480 -120 "
            }
        }
    }
}

// Generated from SVG file notifications_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: __qt_toplevel
    property int iconSize: 20
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
            fillColor: __qt_toplevel.iconColor
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 160 -200 L 160 -280 L 240 -280 L 240 -560 C 240 -615.333 256.667 -664.5 290 -707.5 C 323.333 -750.5 366.667 -778.667 420 -792 L 420 -820 C 420 -836.667 425.833 -850.833 437.5 -862.5 C 449.167 -874.167 463.333 -880 480 -880 C 496.667 -880 510.833 -874.167 522.5 -862.5 C 534.167 -850.833 540 -836.667 540 -820 L 540 -792 C 593.333 -778.667 636.667 -750.5 670 -707.5 C 703.333 -664.5 720 -615.333 720 -560 L 720 -280 L 800 -280 L 800 -200 L 160 -200 M 480 -80 C 458 -80 439.167 -87.8333 423.5 -103.5 C 407.833 -119.167 400 -138 400 -160 L 560 -160 C 560 -138 552.167 -119.167 536.5 -103.5 C 520.833 -87.8333 502 -80 480 -80 "
            }
        }
    }
}

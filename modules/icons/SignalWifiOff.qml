// Generated from SVG file signal_wifi_bad_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: __qt_toplevel
    property var iconHeight: 24
    property var iconColor: "#e3e3e3"
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
                path: "M 480 -120 L 0 -600 C 63.3333 -664.667 136.5 -714.167 219.5 -748.5 C 302.5 -782.833 389.333 -800 480 -800 C 570.667 -800 657.5 -782.833 740.5 -748.5 C 823.5 -714.167 896.667 -664.667 960 -600 L 861 -501 C 845.667 -508.333 829.5 -513.833 812.5 -517.5 C 795.5 -521.167 778.333 -523 761 -523 C 693.667 -523 636.333 -499.333 589 -452 C 541.667 -404.667 518 -347.333 518 -280 C 518 -262.667 519.833 -245.5 523.5 -228.5 C 527.167 -211.5 532.667 -195.333 540 -180 L 480 -120 M 676 -140 L 620 -196 L 704 -280 L 620 -364 L 676 -420 L 760 -336 L 844 -420 L 901 -364 L 817 -280 L 900 -196 L 844 -140 L 760 -223 L 676 -140 "
            }
        }
    }
}

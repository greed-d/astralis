// Generated from SVG file volume_up_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects

Item {
    implicitWidth: 24
    implicitHeight: 24
    component AnimationsInfo : QtObject
    {
        property bool paused: false
        property int loops: 1
        signal restart()
    }
    property AnimationsInfo animations : AnimationsInfo {}
    transform: [
        Translate { x: 0; y: 960 },
        Scale { xScale: width / 960; yScale: height / 960 }
    ]
    id: __qt_toplevel
    Shape {
        id: _qt_node0
        transformOrigin: Item.TopLeft
        ShapePath {
            id: _qt_node1_fill_stroke
            strokeColor: "transparent"
            fillColor: "#ffe3e3e3"
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 560 -131 L 560 -213 C 620 -230.333 668.333 -263.667 705 -313 C 741.667 -362.333 760 -418.333 760 -481 C 760 -543.667 741.667 -599.667 705 -649 C 668.333 -698.333 620 -731.667 560 -749 L 560 -831 C 642.667 -812.333 710 -770.5 762 -705.5 C 814 -640.5 840 -565.667 840 -481 C 840 -396.333 814 -321.5 762 -256.5 C 710 -191.5 642.667 -149.667 560 -131 M 120 -360 L 120 -600 L 280 -600 L 480 -800 L 480 -160 L 280 -360 L 120 -360 M 560 -320 L 560 -642 C 591.333 -627.333 615.833 -605.333 633.5 -576 C 651.167 -546.667 660 -514.667 660 -480 C 660 -446 651.167 -414.5 633.5 -385.5 C 615.833 -356.5 591.333 -334.667 560 -320 " }
        }
    }
}

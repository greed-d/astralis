// Generated from SVG file volume_down_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
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
            PathSvg { path: "M 200 -360 L 200 -600 L 360 -600 L 560 -800 L 560 -160 L 360 -360 L 200 -360 M 640 -320 L 640 -642 C 670 -628 694.167 -606.333 712.5 -577 C 730.833 -547.667 740 -515.333 740 -480 C 740 -444.667 730.833 -412.667 712.5 -384 C 694.167 -355.333 670 -334 640 -320 " }
        }
    }
}

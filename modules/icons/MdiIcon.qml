// Generic renderer for Material Symbols icons.
//
// Material Symbols use a 960x960 viewBox with the coordinate space
// `0 -960 960 960`. Paths are rendered as filled Shape paths and scaled to
// fit the requested `iconSize`, matching the pattern used by the other
// generated icons in this directory.
import QtQuick
import QtQuick.Shapes
import qs.modules.common

Item {
    id: root

    // SVG path data in the `0 -960 960 960` coordinate space.
    property string path: ""
    // Rendered size (square).
    property real iconSize: 24
    // Fill colour. `fillColor` is an alias kept for parity with the older
    // generated icons in this module.
    property color iconColor: Colors.text
    property alias fillColor: root.iconColor

    implicitWidth: root.iconSize
    implicitHeight: root.iconSize

    transform: [
        Translate {
            y: 960
        },
        Scale {
            xScale: root.width / 960
            yScale: root.height / 960
        }
    ]

    Shape {
        transformOrigin: Item.TopLeft

        ShapePath {
            strokeColor: "transparent"
            fillColor: root.iconColor
            fillRule: ShapePath.WindingFill

            PathSvg {
                path: root.path
            }
        }
    }
}

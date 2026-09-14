// Generated from SVG file music_note_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects
import qs.modules.common

Item {
    id: __qt_toplevel
    property int iconSize: 20
    property string iconColor: Colors.text
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
                path: "M 287 -167 C 255.667 -198.333 240 -236 240 -280 C 240 -324 255.667 -361.667 287 -393 C 318.333 -424.333 356 -440 400 -440 C 415.333 -440 429.5 -438.167 442.5 -434.5 C 455.5 -430.833 468 -425.333 480 -418 L 480 -840 L 720 -840 L 720 -680 L 560 -680 L 560 -280 C 560 -236 544.333 -198.333 513 -167 C 481.667 -135.667 444 -120 400 -120 C 356 -120 318.333 -135.667 287 -167 "
            }
        }
    }
}

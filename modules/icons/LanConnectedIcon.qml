// Generated from SVG file lan_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
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
                path: "M 120 -80 L 120 -360 L 240 -360 L 240 -520 L 440 -520 L 440 -600 L 320 -600 L 320 -880 L 640 -880 L 640 -600 L 520 -600 L 520 -520 L 720 -520 L 720 -360 L 840 -360 L 840 -80 L 520 -80 L 520 -360 L 640 -360 L 640 -440 L 320 -440 L 320 -360 L 440 -360 L 440 -80 L 120 -80 "
            }
        }
    }
}

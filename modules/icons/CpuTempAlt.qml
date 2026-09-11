// Generated from SVG file mode_heat_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: __qt_toplevel
    property int iconSize: 20
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
            fillColor: "#ffe3e3e3"
            fillRule: ShapePath.WindingFill
            PathSvg {
                path: "M 160 -400 C 160 -470 176.667 -532.333 210 -587 C 243.333 -641.667 280 -687.667 320 -725 C 360 -762.333 396.667 -790.833 430 -810.5 L 480 -840 L 480 -708 C 480 -683.333 488.333 -663.833 505 -649.5 C 521.667 -635.167 540.333 -628 561 -628 C 572.333 -628 583.167 -630.333 593.5 -635 C 603.833 -639.667 613.333 -647.333 622 -658 L 640 -680 C 688 -652 726.667 -613.167 756 -563.5 C 785.333 -513.833 800 -459.333 800 -400 C 800 -341.333 785.667 -287.833 757 -239.5 C 728.333 -191.167 690.667 -153 644 -125 C 655.333 -141 664.167 -158.5 670.5 -177.5 C 676.833 -196.5 680 -216.667 680 -238 C 680 -264.667 675 -289.833 665 -313.5 C 655 -337.167 640.667 -358.333 622 -377 L 480 -516 L 339 -377 C 319.667 -357.667 305 -336.333 295 -313 C 285 -289.667 280 -264.667 280 -238 C 280 -216.667 283.167 -196.5 289.5 -177.5 C 295.833 -158.5 304.667 -141 316 -125 C 269.333 -153 231.667 -191.167 203 -239.5 C 174.333 -287.833 160 -341.333 160 -400 M 480 -404 L 565 -321 C 576.333 -309.667 585 -297 591 -283 C 597 -269 600 -254 600 -238 C 600 -205.333 588.333 -177.5 565 -154.5 C 541.667 -131.5 513.333 -120 480 -120 C 446.667 -120 418.333 -131.5 395 -154.5 C 371.667 -177.5 360 -205.333 360 -238 C 360 -253.333 363 -268.167 369 -282.5 C 375 -296.833 383.667 -309.667 395 -321 L 480 -404 "
            }
        }
    }
}

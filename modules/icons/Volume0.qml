// Generated from SVG file volume_off_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24.svg
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
            PathSvg { path: "M 792 -56 L 671 -177 C 654.333 -166.333 636.667 -157.167 618 -149.5 C 599.333 -141.833 580 -135.667 560 -131 L 560 -213 C 569.333 -216.333 578.5 -219.667 587.5 -223 C 596.5 -226.333 605 -230.333 613 -235 L 480 -368 L 480 -160 L 280 -360 L 120 -360 L 120 -600 L 248 -600 L 56 -792 L 112 -848 L 848 -112 L 792 -56 M 784 -288 L 726 -346 C 737.333 -366.667 745.833 -388.333 751.5 -411 C 757.167 -433.667 760 -457 760 -481 C 760 -543.667 741.667 -599.667 705 -649 C 668.333 -698.333 620 -731.667 560 -749 L 560 -831 C 642.667 -812.333 710 -770.5 762 -705.5 C 814 -640.5 840 -565.667 840 -481 C 840 -445.667 835.167 -411.667 825.5 -379 C 815.833 -346.333 802 -316 784 -288 M 650 -422 L 560 -512 L 560 -642 C 591.333 -627.333 615.833 -605.333 633.5 -576 C 651.167 -546.667 660 -514.667 660 -480 C 660 -470 659.167 -460.167 657.5 -450.5 C 655.833 -440.833 653.333 -431.333 650 -422 M 480 -592 L 376 -696 L 480 -800 L 480 -592 " }
        }
    }
}

// WifiIcon.qml
import QtQuick
import QtQuick.Shapes

Item {
    id: iconRoot

    property int tier: 0 // Accepts 0, 1, 2, or 3
    property real iconHeight: 20
    property color iconColor: "white"
    property real leftPadding: 2 // Adjust this value or override it from parent

    // Material SVG icon dimensions: 960x680 bounding box
    implicitWidth: ((iconHeight / 680) * 715) + leftPadding
    implicitHeight: iconHeight / 1.35
    width: implicitWidth
    height: implicitHeight

    readonly property var pathData: ["M 480 -120 L 0 -600 C 63.3333 -664.667 136.5 -714.167 219.5 -748.5 C 302.5 -782.833 389.333 -800 480 -800 C 570.667 -800 657.5 -782.833 740.5 -748.5 C 823.5 -714.167 896.667 -664.667 960 -600 L 480 -120 ", "M 480 -120 L 0 -600 C 64 -665.333 137.333 -715 220 -749 C 302.667 -783 389.333 -800 480 -800 C 571.333 -800 658.333 -783 741 -749 C 823.667 -715 896.667 -665.333 960 -600 L 480 -120 M 361 -353 C 377.667 -365 396.167 -374.333 416.5 -381 C 436.833 -387.667 458 -391 480 -391 C 502 -391 523.167 -387.667 543.5 -381 C 563.833 -374.333 582.333 -365 599 -353 L 844 -598 C 792 -637.333 735.167 -667.5 673.5 -688.5 C 611.833 -709.5 547.333 -720 480 -720 C 412.667 -720 348.167 -709.5 286.5 -688.5 C 224.833 -667.5 168 -637.333 116 -598 L 361 -353 ", "M 480 -120 L 0 -600 C 64 -665.333 137.333 -715 220 -749 C 302.667 -783 389.333 -800 480 -800 C 571.333 -800 658.333 -783 741 -749 C 823.667 -715 896.667 -665.333 960 -600 L 480 -120 M 299 -415 C 324.333 -433.667 352.333 -448.167 383 -458.5 C 413.667 -468.833 446 -474 480 -474 C 514 -474 546.333 -468.833 577 -458.5 C 607.667 -448.167 635.667 -433.667 661 -415 L 844 -598 C 792 -637.333 735.167 -667.5 673.5 -688.5 C 611.833 -709.5 547.333 -720 480 -720 C 412.667 -720 348.167 -709.5 286.5 -688.5 C 224.833 -667.5 168 -637.333 116 -598 L 299 -415 ", "M 480 -120 L 0 -600 C 64 -665.333 137.333 -715 220 -749 C 302.667 -783 389.333 -800 480 -800 C 571.333 -800 658.333 -783 741 -749 C 823.667 -715 896.667 -665.333 960 -600 L 480 -120 M 232 -482 C 267.333 -507.333 306 -527.167 348 -541.5 C 390 -555.833 434 -563 480 -563 C 526 -563 570 -555.833 612 -541.5 C 654 -527.167 692.667 -507.333 728 -482 L 844 -598 C 792 -637.333 735.167 -667.5 673.5 -688.5 C 611.833 -709.5 547.333 -720 480 -720 C 412.667 -720 348.167 -709.5 286.5 -688.5 C 224.833 -667.5 168 -637.333 116 -598 L 232 -482 "]

    Shape {
        id: shape
        x: iconRoot.leftPadding
        width: parent.width - iconRoot.leftPadding
        height: parent.height

        // Scale the internal vector canvas to fit parent bounds
        transform: [
            Translate {
                y: 800
            },
            Scale {
                xScale: iconRoot.height / 680
                yScale: iconRoot.height / 680
            }
        ]

        ShapePath {
            fillColor: iconRoot.iconColor
            strokeColor: "transparent"

            PathSvg {
                path: iconRoot.pathData[Math.max(0, Math.min(iconRoot.tier, 3))]
            }
        }
    }
}

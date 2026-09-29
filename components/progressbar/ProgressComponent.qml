import QtQuick

Rectangle {
    id: root
    property real value: 0
    property bool indeterminate: false
    property color fillColor: "#ffffff"
    property color fillBarBackground: "#ffff00"
    property bool animated: true
    property real progressBarHeight: 120
    property real progressBarWidth: 24

    readonly property real clamped: Math.min(1, Math.max(0, value))

    implicitWidth: progressBarHeight
    implicitHeight: progressBarWidth

    radius: height / 2
    color: fillBarBackground
    clip: true

    Rectangle {
        visible: !root.indeterminate
        width: root.width * root.clamped
        height: parent.height
        radius: root.radius
        color: root.fillColor

        Behavior on width {
            enabled: root.animated
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
    }
    Rectangle {
        id: segment
        visible: root.indeterminate
        width: root.width * 0.3
        height: parent.height
        radius: root.radius
        color: root.fillColor

        SequentialAnimation on x {
            running: root.indeterminate && root.visible
            loops: Animation.Infinite
            NumberAnimation {
                from: -segment.width
                to: root.width
                duration: 1200
                easing.type: Easing.InOutQuad
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import qs.modules.common

Rectangle {
    id: btn

    property alias content: holder.data   // put any child (Text, icon) inside
    property int size: 40
    property bool primary: false          // filled accent style for the big button
    property bool enabledButton: true

    signal clicked

    implicitWidth: size
    implicitHeight: size
    Layout.alignment: Qt.AlignVCenter
    radius: size / 2                      // half of size = perfect circle

    opacity: enabledButton ? 1 : 0.4
    color: primary ? (ma.pressed ? Colors.secondary : Colors.primary) : (ma.containsMouse ? Colors.surface1 : Colors.surface0)

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }
    scale: ma.pressed ? 0.94 : 1
    Behavior on scale {
        NumberAnimation {
            duration: 80
        }
    }

    Item {
        id: holder
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        enabled: btn.enabledButton
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}

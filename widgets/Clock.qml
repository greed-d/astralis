import QtQuick
import qs.modules
import qs.modules.common

Rectangle {
    id: root

    color: Colors.surface0
    radius: 20

    implicitWidth: clock.implicitWidth + 20
    implicitHeight: clock.implicitHeight + 10

    Time {
        id: clock

        anchors.centerIn: parent
    }
}

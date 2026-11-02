import QtQuick
import qs.modules
import qs.modules.common
import qs.components.popup.calendar

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

    MouseArea {
        anchors.fill: parent
        onClicked: calPopup.visible = !calPopup.visible
    }
    CalendarPopup {
        id: calPopup
        anchorItem: clock
    }
}

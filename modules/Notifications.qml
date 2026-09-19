import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.icons
import qs.modules.common
import qs.services.notification
import qs.components.popup.notifications

RowLayout {
    id: root
    NotificationIcon {
        iconColor: Colors.text
    }

    MouseArea {
        anchors.fill: parent
        onClicked: NotificationService.toggleHistory()
    }
}

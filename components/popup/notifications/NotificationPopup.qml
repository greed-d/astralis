import Quickshell
import QtQuick
import Quickshell.Services.Notifications
import QtQuick.Layouts
import qs.services.notification
import qs.modules.common

PanelWindow {
    anchors {
        top: true
        right: true
    }
    margins {
        top: Config.data.bar.size + 12 + 4
        right: 12
    }
    implicitWidth: 380
    implicitHeight: Math.max(1, column.implicitHeight)
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    // Component.onCompleted: console.log("initial count:", NotificationService.trackedNotifications.count)
    // Connections {
    //     target: NotificationService.trackedNotifications
    //     function onCountChanged() {
    //         //     console.log("tracked count now:", NotificationService.trackedNotifications.count);
    //     }
    //     // Component.onCompleted: console.log("timer interval:", interval, "running:", running)
    // }

    ColumnLayout {
        id: column
        width: parent.width
        spacing: 10

        Repeater {

            model: NotificationService.trackedNotifications

            delegate: NotificationCard {
                id: cardWrap
                required property var modelData
                Layout.fillWidth: true
                summary: modelData.summary
                body: modelData.body
                image: modelData.image || ""
                appIcon: modelData.appIcon || ""
                urgency: modelData.urgency
                actions: modelData.actions || []
                onDismissed: modelData.dismiss()
                onCloseClicked: modelData.dismiss()

                Timer {
                    running: modelData.urgency !== NotificationUrgency.Critical
                    interval: Config.notifications.timeout * 1000
                    onTriggered: modelData.dismiss()
                }
            }
        }
    }
}

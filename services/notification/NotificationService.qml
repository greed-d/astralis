pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick.Layouts

Singleton {
    id: root
    property alias trackedNotifications: server.trackedNotifications
    property alias history: historyModel
    property bool historyOpen: false

    function toggleHistory(): void {
        historyOpen = !historyOpen;
    }

    ListModel {
        id: historyModel
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            //console.log("[NotificationService] onNotification fired:", n.appName, n.summary);
            historyModel.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            n.tracked = true;
        }
    }
}

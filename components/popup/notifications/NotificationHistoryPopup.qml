import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick.Layouts
import qs.modules.common
import qs.services.notification

Item {
    id: root
    property bool centerOpen: false

    IpcHandler {
        id: notifIpc
        target: "notifications"
        function toggle(): void {
            NotificationService.toggleHistory();
        }
        function show(): void {
            NotificationService.historyOpen = true;
        }
        function hide(): void {
            NotificationService.historyOpen = false;
        }
    }

    PanelWindow {
        visible: NotificationService.historyOpen
        anchors {
            top: true
            right: true
        }
        margins {
            top: Config.data.bar.size + 12 + 4
            right: 12
        }
        implicitWidth: 380
        implicitHeight: Math.min(500, 60 + NotificationService.history.count * 80)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        MouseArea {
            anchors.fill: parent
            onClicked: NotificationService.historyOpen = false
        }

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: Colors.background0
            MouseArea {
                anchors.fill: parent
                onClicked: notifIpc.hide()
            }
            ColumnLayout {
                id: historyColumn
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10
                RowLayout {
                    Layout.fillWidth: true
                    TextBox {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: Colors.secondary
                        font.pixelSize: Config.theme.font.size + 2
                        font.bold: true
                    }
                    TextBox {
                        text: "Clear all"
                        visible: NotificationService.history.count > 0
                        font.pixelSize: Config.theme.font.size - 1
                        font.bold: true
                        color: Colors.error
                        MouseArea {
                            anchors.fill: parent
                            onClicked: NotificationService.history.clear()
                        }
                    }
                }

                ListView {
                    id: notifList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 6
                    model: NotificationService.history
                    delegate: NotificationCard {
                        width: notifList.width
                        height: implicitHeight
                        summary: model.summary
                        body: model.body
                        urgency: model.urgency
                        timeText: model.time
                    }
                }
            }
        }
    }
}

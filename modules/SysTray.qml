import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

RowLayout {
    id: root
    spacing: 6

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayIcon
            required property SystemTrayItem modelData
            implicitWidth: 18
            implicitHeight: 18

            IconImage {
                anchors.fill: parent
                source: trayIcon.modelData.icon
                asynchronous: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: mouse => {
                    switch (mouse.button) {
                    case Qt.LeftButton:
                        trayIcon.modelData.activate();
                        break;
                    case Qt.MiddleButton:
                        trayIcon.modelData.secondaryActivate();
                        break;
                    case Qt.RightButton:
                        if (trayIcon.modelData.hasMenu)
                            menuAnchor.open();
                        break;
                    }
                }

                onWheel: wheel => {
                    trayIcon.modelData.scroll(wheel.angleDelta.y, false);
                }
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: trayIcon.modelData.menu
                anchor.window: root.QsWindow.window
                anchor.rect: Qt.rect(trayIcon.mapToItem(null, 0, 0).x, trayIcon.mapToItem(null, 0, trayIcon.height).y, 1, 1)
            }
        }
    }
}

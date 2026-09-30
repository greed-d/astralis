pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.SystemTray

Singleton {
    property var systray: SystemTray.items
}

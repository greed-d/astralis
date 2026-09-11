pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
    readonly property var toplevels: ToplevelManager.toplevels
    readonly property Toplevel active: ToplevelManager.activeToplevel
    readonly property int windowCount: toplevels.values.length

    function windowList() {
        return toplevels.values;
    }

    function printWindows() {
        const list = toplevels.values;
        for (let i = 0; i < list.length; i++) {
            const t = list[i];
        }
    }

    Component.onCompleted: printWindows()

    onWindowCountChanged: printWindows()

    onActiveChanged: {}
}

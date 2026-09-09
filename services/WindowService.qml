pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
    readonly property var toplevels: ToplevelManager.toplevels
    readonly property Toplevel active: ToplevelManager.activeToplevel

    function windowList() {
        let out = [];
        for (let i = 0; i < toplevels.count; i++)
            out.push(toplevels.get(i));
        return out;
    }

    function printWindows() {
        for (let i = 0; i < toplevels.count; i++) {
            const t = toplevels.get(i);
            console.log(`[${i}] title="${t.title}" appId="${t.appId}" activated=${t.activated}`);
        }
    }

    Component.onCompleted: printWindows()

    // re-log whenever the window set changes (open/close)
    Connections {
        target: toplevels
        function onCountChanged() {
            printWindows();
        }
    }

    // log focus changes separately
    onActiveChanged: {
        if (active)
            console.log(`focused: "${active.title}" (${active.appId})`);
    }
}

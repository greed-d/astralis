pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root
    property var screen: null
    property var workspaces: []
    readonly property var filteredWorkspaces: screen ? workspaces.filter(w => w.output === screen.name) : workspaces
    function forOutput(outputName) {
        return outputName ? workspaces.filter(w => w.output === outputName) : workspaces;
    }
    function switchTo(index) {
        Quickshell.execDetached(["umbriel", "msg", `workspace-switch:${index.toString()}`]);
    }

    Process {
        id: wsproc
        command: ["umbriel", "subscribe", "workspaces"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (!line || line.trim().length === 0)
                    return;
                let parsed;
                try {
                    parsed = JSON.parse(line);
                } catch (e) {
                    return;
                }

                if (parsed.event === "workspaces" && Array.isArray(parsed.data)) {
                    root.workspaces = parsed.data;
                } else {
                    console.warn("WorkspaceService: unexpected payload, ignored:", line);
                }
            }
        }

        onExited: (code, status) => {
            console.warn("WorspaceService: umbriel subscribe exited, restart");
            restartTimer.start();
        }
    }
    Timer {
        id: restartTimer
        interval: 1000
        onTriggered: wsproc.running = true
        triggeredOnStart: true
    }
}

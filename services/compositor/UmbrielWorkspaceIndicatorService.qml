pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root
    property var screen: null
    property var workspaces: []
    property bool onlyActive: false
    readonly property var filteredWorkspaces: screen ? workspaces.filter(w => w.output === screen.name) : workspaces
    function forOutput(outputName) {
        return outputName ? workspaces.filter(w => w.output === outputName) : workspaces;
    }
    function switchTo(index) {
        const payload = JSON.stringify({
            cmd: "msg",
            arg: `workspace-switch:${index}`
        }) + "\n";
        umbrielSocket.write(payload);
        umbrielSocket.flush();
    }

    Socket {
        id: umbrielSocket
        path: Quickshell.env("UMBRIEL_SOCKET")
        connected: true

        onConnectedChanged: {
            if (connected) {
                umbrielSocket.write('{"cmd":"subscribe","events":["workspaces"]}\n');
                umbrielSocket.flush();
            } else {
                reconnectTimer.start();
            }
        }

        onError: error => console.warn("umbriel socket error:", error)

        parser: SplitParser {
            onRead: line => {
                if (!line || line.trim().length === 0)
                    return;
                let parsed;
                try {
                    parsed = JSON.parse(line);
                } catch (e) {
                    console.warn("invalid JSON:", line);
                    return;
                }
                if (parsed.event === "workspaces" && Array.isArray(parsed.data)) {
                    root.workspaces = parsed.data;
                }
            }
        }
    }

    Timer {
        id: reconnectTimer
        interval: 250
        onTriggered: umbrielSocket.connected = true
    }
}

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real ramPercentUse: 0.0
    property real ramUsed: 0.0

    Process {
        id: ramProc

        command: ["sh", "-c", "free -b | awk '/^Mem:/ {printf \"%.0f %.1f\\n\", $3/$2*100, $3/1024/1024/1024}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                let values = this.text.trim().split(/\s+/);

                if (values.length >= 2) {
                    root.ramPercentUse = parseFloat(values[0]) || 0.0;
                    root.ramUsed = parseFloat(values[1]) || 0.0;
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: ramProc.running = true
    }
}

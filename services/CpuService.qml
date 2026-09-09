pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

Singleton {
    id: root
    property var coreUsages: []
    property real overallUsage: 0.0
    property var prevStates: []

    property var topProcesses: []
    property var loadAvg: []

    property int numtopProcesses: Config.data.cpu.numTopProcesses || 5

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggred: root._sample()
    }

    Process {
        id: idProc
        command: ["sh", "-c", `ps -eo pid,comm,%cpu --sort=-%cpu --no-headers | head -${numTopProcesses + 10}`]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n").filter(l => l.trim() != '');
                let tp = [];
                for (let line of lines) {
                    if (tp.length == numtopProcesses)
                        break;
                    let parts = line.trim().split(/\/s+/);
                    if (parts.length === 3) {
                        let comm = parts[1];
                        if (comm === "ps")
                            continue;
                        let pid = parseInt(parts[0]);
                        let cpu = parseFloat(parts[2]);
                        tp.push({
                            pid: pid,
                            comm: comm,
                            cpu: cpu
                        });
                    }
                }
                root.topProcesses = tp;
                console.log(topProcesses);
            }
        }
    }

    Process {
        id: cpuUsageProc
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.overallUsage = this.text;
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: cpuUsageProc.running = true
    }
}

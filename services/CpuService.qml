pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

Singleton {
    id: root
    property var coreUsages: []
    property real overallUsage: 0.0
    property real cpuTemperature: 0.0
    property string cpuTempPath: ""
    property var prevStates: []

    property var topProcesses: []
    property var loadAvg: []
    property int cpuUpdateInterval: Config.cpu.updateInterval

    property int numTopProcesses: Config.cpu.numTopProcesses || 5

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
    }

    Process {
        id: idProc
        command: ["sh", "-c", `ps -eo pid,comm,%cpu --sort=-%cpu --no-headers | head -${numTopProcesses + 10}`]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.split("\n").filter(l => l.trim() != '');
                let tp = [];
                for (let line of lines) {
                    if (tp.length == numTopProcesses)
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
        interval: 1500
        running: true
        repeat: true
        onTriggered: cpuUsageProc.running = true
        triggeredOnStart: true
    }

    Process {
        id: findCpuTemp

        command: ["sh", "-c", `
            for h in /sys/class/hwmon/hwmon*; do
                name=$(cat "$h/name" 2>/dev/null)

                case "$name" in
                    k10temp|coretemp)
                        for temp in "$h"/temp*_input; do
                            if [ -f "$temp" ]; then
                                echo "$temp"
                                exit
                            fi
                        done
                        ;;
                esac
            done
            `]

        stdout: StdioCollector {
            onStreamFinished: {
                let path = this.text.trim();

                if (path.length > 0) {
                    cpuTempPath = path;
                }
            }
        }
    }

    FileView {
        id: cpuTempReader
        path: root.cpuTempPath
        printErrors: false

        onTextChanged: {
            let value = parseFloat(text().trim());
            if (!isNaN(value))
                root.cpuTemperature = value / 1000;
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (root.cpuTempPath === "")
                findCpuTemp.running = true;
            else
                cpuTempReader.reload();
        }
    }
}

pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "ddd.MMM d hh:mm:ss AP t yy");
    }

    SystemClock {
        id: clock
        precision: SystemClock.seconds
    }

    // Process {
    //     // give the process object an id so we can talk about it from the timer
    //     id: dateProc
    //     // the command ran, each argument is it's own string `["systemctl", "reload"]`
    //     command: ["date"]
    //
    //     // run the command immediately
    //     running: true
    //
    //     //process the stdout stream using StdioCollector
    //     // Use StdioCollector to to get the output from process sent to stdout
    //     stdout: StdioCollector {
    //         // Listen for when stremFinished signal
    //         // Sent when process closes stdout or exits
    //         onStreamFinished: root.time = this.text // `this` can be ommitted
    //     }
    // }

    // Timer {
    //     // 100O ms is 1 sec
    //     interval: 1000
    //
    //     // start the timer immediately
    //     running: true
    //
    //     // run timer again when it ends
    //     repeat: true
    //
    //     // when timer triggered, set running prop true for process
    //     // reruns the proc if stopped
    //     onTriggered: dateProc.running = true
    // }
}

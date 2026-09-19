//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "./shell/Bar/"
import "./modules/common/"
import "./services/"

ShellRoot {
    LazyLoader {
        active: true
        component: Bar {
            position: Types.stringToPosition(Config.data.bar.position)
        }
    }

    Process {
        running: true
        command: ["sh", "-c", "pgrep -x awww-daemon || awww-daemon"]
    }
    Process {
        id: applyProcess
        stderr: SplitParser {
            onRead: data => console.log("awww img error:", data)
        }
    }
}

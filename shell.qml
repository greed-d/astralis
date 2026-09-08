import QtQuick
import Quickshell
import "./shell/Bar/"
import "./modules/common/"

ShellRoot {
    LazyLoader {
        active: true
        component: Bar {
            position: Types.stringToPosition(Config.data.bar.position)
        }
    }
}

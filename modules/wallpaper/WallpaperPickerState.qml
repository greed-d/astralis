pragma Singleton
import Quickshell

Singleton {
    id: root
    property bool open: false
    function toggle() {
        open = !open;
    }
}

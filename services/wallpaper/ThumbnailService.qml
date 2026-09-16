pragma Singleton
import Quickshell
import Quickshell.Io
import QtQml
import qs.services.wallpaper

Singleton {
    id: root

    readonly property string cacheDir: Quickshell.cachePath("wallpaper-picker/thumbnails")

    function pathFor(wallpaperPath) {
        return cacheDir + "/" + Qt.md5(wallpaperPath) + ".png";
    }

    Component.onCompleted: ensureDirProcess.running = true

    Process {
        id: ensureDirProcess
        command: ["mkdir", "-p", root.cacheDir]
    }
}

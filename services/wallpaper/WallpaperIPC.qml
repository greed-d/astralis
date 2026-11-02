pragma Singleton

import QtQml
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property Process setWallpaperProcess: Process {
        command: []
    }

    function setWallpaper(fileUrl) {
        setWallpaperProcess.command = ["awww", "img", fileUrl.toString().replace("file://", ""), "--transition-type", "random", "--transition-duration", "1.25", "--transition-fps", "165"];

        setWallpaperProcess.running = true;
    }

    function toggle() {
    }
}

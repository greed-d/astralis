import QtQuick
import Quickshell.Io
import qs.services.wallpaper

Item {
    id: root

    property string directory: ""
    readonly property var wallpapers: WallpaperService.wallpapers
    property string selectedWallpaper: ""

    function select(path) {
        selectedWallpaper = path;
    }

    function apply() {
        if (selectedWallpaper.length === 0) {
            //console.log("No wallpaper found");
            return;
        }
        applyProcess.command = ["awww", "img", selectedWallpaper];
        applyProcess.running = true;
    }

    onDirectoryChanged: {
        if (directory.length > 0)
            WallpaperService.load(directory);
    }

    Process {
        id: applyProcess
    }
}

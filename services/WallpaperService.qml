import QtQuick
import Quickshell.Io

Item {
    id: root

    property var wallpapers: ["/home/greed/Pictures/Wallpaper/walls-catppuccin-mocha/basement.jpg", "/home/greed/Pictures/Wallpaper/walls-catppuccin-mocha/blue-landscape.png", "/home/greed/Pictures/Wallpaper/walls-catppuccin-mocha/black-hole.png"]

    property string current: ""

    Process {
        id: setWallpaper
    }

    function setWallpaperTo(path) {
        setWallpaper.command = ["awww", "img", path];
        setWallpaper.running = true;
        root.current = path;
    }
}

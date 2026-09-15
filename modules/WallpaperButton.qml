import QtQuick
import QtQuick.Controls
import Quickshell.Io

Button {
    id: root

    property var wallpapers: ["/home/greed/Pictures/Wallpaper/walls-catppuccin-mocha/basement.jpg", "/home/greed/Pictures/Wallpaper/walls-catppuccin-mocha/blue-landscape.png", "/home/greed/Pictures/Wallpaper/walls-catppuccin-mocha/black-hole.png"]

    text: "🖼"

    Process {
        id: setWallpaper
        onExited: (code, status) => {
            if (code !== 0)
                console.log("swww failed, code:", code);
        }
    }

    Process {
        id: wallpaperDaemon
        command: ["awww-daemon"]
    }
    Timer {
        running: false
        repeat: false
        triggeredOnStart: true
        onTriggered: wallpaperDaemon
    }

    onClicked: {
        const path = root.wallpapers[Math.floor(Math.random() * root.wallpapers.length)];
        console.log("setting wallpaper:", path);
        setWallpaper.command = ["awww", "img", path];
        wallpaperDaemon.running = true;
        setWallpaper.running = true;
    }
}

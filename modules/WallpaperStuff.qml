import qs.services
import QtQuick

Item {
    Component.onCompleted: {
        WallpaperService.load("/home/deekshit.bhattarai/Pictures/walls-catppuccin-mocha/");
    }
    Text {
        text: WallpaperService.wallpapers.length + " wallpapers found"
    }
}

pragma Singleton

import Quickshell
import Quickshell.Io
import QtCore
import Qt.labs.folderlistmodel
import qs.modules.common
import qs.services.wallpaper

Singleton {
    id: root

    property url wallpaperDirectory: Config.wallpaper.directory
    property url currentWallpaper: ""
    property alias model: wallpaperModel
    property bool popupVisible: false

    onWallpaperDirectoryChanged: {
        console.log("WallpaperService: wallpaperDirectory =", root.wallpaperDirectory);
    }

    onCurrentWallpaperChanged: {
        console.log("WallpaperService: currentWallpaper =", root.currentWallpaper);
    }

    onPopupVisibleChanged: {
        console.log("WallpaperService: popupVisible =", root.popupVisible);
    }

    FolderListModel {
        id: wallpaperModel

        // folder: "file:///home/greed/Pictures/Wallpaper/walls-catppuccin-mocha/"
        folder: "file://" + root.wallpaperDirectory

        showDirs: false
        showFiles: true
        showHidden: false

        onFolderChanged: {
            // console.log("MODEL FOLDER CHANGED:", folder)
        }

        // onCountChanged: {
        //     console.log("MODEL COUNT:", count)
        //
        //     for (let i = 0; i < count; ++i) {
        //         console.log(
        //             i,
        //             get(i, "fileName"),
        //             get(i, "filePath")
        //         )
        //     }
        // }
    }
    function togglePopup() {
        popupVisible = !popupVisible;
    }

    function openPopup() {
        popupVisible = true;
    }

    function closePopup() {
        popupVisible = false;
    }

    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            root.togglePopup();
        }

        function open(): void {
            root.openPopup();
        }

        function close(): void {
            root.closePopup();
        }
    }
}

// Singleton {
//     id: root
//
//     property var wallpapers: []
//
//     function load(manifestPath) {
//         listFile.path = manifestPath;
//         root.wallpapers = parseManifest(listFile.text());
//     }
//
//     function parseManifest(content) {
//         return content.split("\n").map(function (line) {
//             return line.trim();
//         }).filter(function (line) {
//             return line.length > 0;
//         }).map(function (line) {
//             return {
//                 path: line
//             };
//         });
//     }
//
//     FileView {
//         id: listFile
//         blockLoading: true
//         watchChanges: true
//         onFileChanged: {
//             reload();
//             root.wallpapers = root.parseManifest(text());
//             //console.log(root.parseManifest());
//         }
//     }
// }


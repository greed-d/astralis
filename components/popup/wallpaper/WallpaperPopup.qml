import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt.labs.folderlistmodel
import qs.modules.common
import qs.services.wallpaper
import qs.components.popup.wallpaper

PanelWindow {
    id: root

    implicitWidth: 700
    implicitHeight: 500

    color: "transparent"

    visible: WallpaperService.popupVisible

    Rectangle {
        anchors.fill: parent

        radius: 16
        color: Colors.background2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            Text {
                text: "Wallpapers"

                color: Colors.text
                font.pixelSize: 20
                font.bold: true
            }

            GridView {
                id: wallpaperGrid

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: WallpaperService.model

                cellWidth: 200
                cellHeight: 130

                clip: true

                delegate: WallpaperThumbnail {
                    required property string fileName
                    required property url fileUrl

                    width: wallpaperGrid.cellWidth - 10
                    height: wallpaperGrid.cellHeight - 10

                    source: fileUrl

                    onClicked: {
                        // console.log("thumbnail clicked");
                        // console.log(fileUrl);
                        // console.log("WallpaperIPC:", WallpaperIPC);
                        // console.log("setWallpaper:", WallpaperIPC.setWallpaper);
                        WallpaperIPC.setWallpaper(fileUrl);
                        WallpaperService.popupVisible = false;
                    }
                }
            }
        }
    }
}

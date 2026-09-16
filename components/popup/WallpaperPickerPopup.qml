import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.wallpaper
import qs.modules.common
import qs.services.wallpaper

PopupWindow {
    id: root

    property alias directory: picker.directory

    implicitWidth: 500
    implicitHeight: 440
    visible: WallpaperPickerState.open

    anchor {
        edges: Edges.Bottom | Edges.Left
        gravity: Edges.Bottom | Edges.Right
    }

    WallpaperPicker {
        id: picker
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.background2

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            GridView {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                cellWidth: 140
                cellHeight: 90
                model: picker.wallpapers
                clip: true

                delegate: Rectangle {
                    width: 130
                    height: 80
                    color: Colors.surface0
                    border.width: picker.selectedWallpaper === modelData.path ? 3 : 0
                    border.color: Colors.primary

                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        sourceSize.width: 130
                        sourceSize.height: 80
                        property string cachePath: ThumbnailService.pathFor(modelData.path)
                        property bool loadedFromOriginal: false

                        source: "file://" + cachePath

                        onStatusChanged: {
                            console.log("Stuff0");
                            if (status === Image.Error && !loadedFromOriginal) {
                                loadedFromOriginal = true;
                                source = "file://" + modelData.path;
                            } else if (status === Image.Ready && loadedFromOriginal) {
                                grabToImage(function (result) {
                                    console.log("Stuff");
                                    result.saveToFile(cachePath);
                                });
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: picker.select(modelData.path)
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 32
                color: Colors.surface1

                Text {
                    anchors.centerIn: parent
                    color: Colors.text
                    text: "Apply"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("apply clicked, selected:", picker.selectedWallpaper);
                        picker.apply();
                    }
                }
            }
        }
    }
}

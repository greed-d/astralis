import QtQuick
import qs.services

Row {
    id: root

    property var service: WallpaperService   // expects a WallpaperService instance
    spacing: 10

    Repeater {
        model: root.service.wallpapers

        Rectangle {
            width: 100
            height: 100
            color: "gray"
            border.width: modelData === root.service.current ? 3 : 0
            border.color: "white"

            Image {
                anchors.fill: parent
                source: "file://" + modelData
                fillMode: Image.PreserveAspectCrop
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.service.setWallpaperTo(modelData)
            }
        }
    }
}

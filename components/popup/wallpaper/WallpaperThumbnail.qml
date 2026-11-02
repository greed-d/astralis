import QtQuick
import QtQuick.Controls
import qs.modules.common

Item {
    id: root

    required property url source

    signal clicked

    Rectangle {
        anchors.fill: parent

        radius: 12
        color: Colors.background2

        clip: true

        Image {
            anchors.fill: parent

            source: root.source

            fillMode: Image.PreserveAspectCrop

            asynchronous: true
            cache: true

            mipmap: true
        }

        MouseArea {
            anchors.fill: parent

            onClicked: root.clicked()
        }
    }
}

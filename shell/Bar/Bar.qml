import QtQuick
import Quickshell
import qs.modules.common
import qs.modules

Scope {
    id: root
    property int position: Types.Position.Top
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            implicitHeight: Config.data.bar.size
            color: Config.data.theme.colors.background

            anchors {
                top: root.position == Types.Position.Top
                bottom: root.position == Types.Position.Bottom
                left: true
                right: true
            }

            Network {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
            }
        }
    }
}

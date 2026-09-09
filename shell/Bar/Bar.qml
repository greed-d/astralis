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

            RowLayout {
                id: rowLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 8
                CpuUsage {}
                Text {
                    text: "•"
                    color: Config.data.theme.colors.textMuted
                    visible: cpuTemp.visible
                }
                CpuTemp {
                    visible: Config.data.cpu.temperature.visible
                }
                Network {}

                // add more left-side modules here
            }
            RowLayout {
                id: rowCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                CpuUsage {}
                Network {}
                // add more left-side modules here
            }

            RowLayout {
                id: rowRight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                anchors.rightMargin: 8

                Memory {}
                Network {}
                // add more left-side modules here
            }
        }
    }
}

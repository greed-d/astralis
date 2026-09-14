import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.modules
import qs.widgets

Scope {
    id: root
    property int position: Types.Position.Top
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            margins {
                top: 8
                left: 8
                right: 8
            }
            screen: modelData
            implicitHeight: Config.data.bar.size
            color: "transparent"

            anchors {
                top: root.position == Types.Position.Top
                bottom: root.position == Types.Position.Bottom
                left: true
                right: true
            }
            Rectangle {
                anchors.fill: parent
                radius: 12
                color: Colors.background2
            }

            RowLayout {
                id: rowLeft
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 15
                spacing: 12

                WorkspaceIndicator {
                    screen: bar.screen
                    onlyActive: true
                }
                WaylandWindow {}

                // CPU Container (Collapses automatically when temp is hidden)
                RowLayout {

                    CpuUsage {
                        Layout.preferredWidth: implicitWidth + 4 // Fixed width for usage
                    }

                    Text {
                        text: "•"
                        color: Colors.text
                        visible: cpuTemp.visible
                    }

                    CpuTemp {
                        id: cpuTemp
                        visible: Config.cpu.temperature.visible
                        Layout.preferredWidth: implicitWidth + 4 // Increased width to fit icon + text
                    }
                }
            }
            RowLayout {
                id: rowCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10
                Clock {}
            }

            RowLayout {
                id: rowRight
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                anchors.rightMargin: 15

                Memory {}
                Network {}
                Mpris {}
            }
        }
    }
}

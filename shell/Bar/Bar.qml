import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.bar
import qs.modules.wallpaper
import qs.modules.cpu
import qs.modules
import qs.widgets
import qs.components.popup
import qs.components.popup.notifications

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

            Component {
                id: separatorComponent

                TextBox {
                    text: "  |  "
                }
            }
            Component {
                id: umbrielWorkspacesComponent
                WorkspaceIndicator {
                    screen: bar.screen
                    onlyActive: false
                }
            }
            Component {
                id: workspacesComponent
                UmbrielWorkspaceIndicator {
                    onlyActive: true
                }
            }
            Component {
                id: focusedWindowComponent
                WaylandWindow {}
            }

            Component {
                id: cpuComponent
                RowLayout {
                    CpuUsage {
                        Layout.preferredWidth: implicitWidth
                    }
                    Text {
                        text: "•"
                        color: Colors.text
                        visible: cpuTemp.visible
                    }
                    CpuTemp {
                        id: cpuTemp
                        visible: Config.cpu.temperature.visible
                        Layout.preferredWidth: implicitWidth
                    }
                }
            }
            Component {
                id: ramComponent
                Memory {}
            }
            Component {
                id: networkComponent
                Network {}
            }
            Component {
                id: mprisComponent
                Mpris {}
            }
            Component {
                id: clockComponent
                Clock {}
            }
            Component {
                id: pipewireComponent
                Pipewire {}
            }
            Component {
                id: wallpaperButton
                WallpaperButton {}
            }
            Component {
                id: batteryComponent
                Battery {}
            }
            Component {
                id: systrayComponent
                SysTray {}
            }
            Component {
                id: notificationComponent
                Notifications {}
            }

            readonly property var widgetComponents: {
                "umbriel_workspaces": umbrielWorkspacesComponent,
                "workspaces": workspacesComponent,
                "focusedWindow": focusedWindowComponent,
                "cpu": cpuComponent,
                "ram": ramComponent,
                "network": networkComponent,
                "mpris": mprisComponent,
                "clock": clockComponent,
                "pipewire": pipewireComponent,
                "wallpaper_button": wallpaperButton,
                "battery": batteryComponent,
                "systray": systrayComponent,
                "notification": notificationComponent,
                "separator": separatorComponent
            }

            LayoutSection {
                section: "left"
                widgetComponents: bar.widgetComponents

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 15
                }
            }

            LayoutSection {
                section: "center"
                widgetComponents: bar.widgetComponents

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
            }

            LayoutSection {
                section: "right"
                widgetComponents: bar.widgetComponents

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 15
                }
            }

            WallpaperPickerPopup {
                id: wallpaperPopup
                anchor.window: bar
                anchor.rect.x: bar.width / 2 - width / 2
                anchor.rect.y: bar.height
                directory: "/home/deekshit.bhattarai/Pictures/walls-catppuccin-mocha/wallpapers.txt"
            }

            NotificationPopup {}
            NotificationHistoryPopup {}
        }
    }
}

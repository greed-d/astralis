import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.modules.common
import qs.modules.icons
import qs.services
import qs.components.progressbar

PopupWindow {
    id: popupBattery

    property Item anchorItem: null

    readonly property string deviceState: UPowerDeviceState.toString(Upower.state)
    readonly property bool isCharging: deviceState === "Charging"
    readonly property bool isDischarging: deviceState === "Discharging"
    readonly property bool isFull: deviceState === "FullyCharged"

    readonly property real batteryPercent: Upower.percentage * 100

    color: "transparent"
    implicitWidth: 350
    implicitHeight: col.implicitHeight + 24

    anchor.item: anchorItem

    anchor.rect.x: anchorItem ? (anchorItem.width / 2 - implicitWidth / 2) : 0
    anchor.rect.y: anchorItem ? anchorItem.height + 6 : 0

    Rectangle {
        id: box
        anchors.fill: parent
        implicitHeight: col.implicitHeight
        color: Colors.background2
        radius: 12

        ColumnLayout {
            id: col
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 8

            RowLayout {
                BatteryIcon {
                    id: batteryIcon
                    percent: popupBattery.batteryPercent
                    iconSize: 24 * 2
                    charging: popupBattery.isCharging
                    alert: popupBattery.batteryPercent < 10
                }

                ProgressComponent {
                    Layout.fillWidth: true
                    value: Upower.percentage
                    progressBarWidth: 24
                    fillColor: Colors.primary
                    fillBarBackground: Colors.surface0
                }
                Text {
                    text: `${popupBattery.batteryPercent}%`
                    font.pixelSize: 24
                    color: Colors.text
                    font.weight: Font.Bold
                }
                Text {
                    text: popupBattery.deviceState
                    font.pixelSize: 18
                    color: Colors.text
                    font.weight: Font.DemiBold
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                uniformCellSizes: true

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: healthCol.implicitHeight + 16     // 8px padding top and bottom
                    radius: 8
                    color: Colors.surface0

                    ColumnLayout {
                        id: healthCol
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Health"
                            color: Colors.secondary
                            font.pixelSize: 12
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: `${Math.round(Upower.healthPercentage)}%`
                            color: Colors.text
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: capacityCol.implicitHeight + 16
                    radius: 8
                    color: Colors.surface0

                    ColumnLayout {
                        id: capacityCol
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Capacity"
                            color: Colors.secondary
                            font.pixelSize: 12
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: `${Upower.energyCapacity.toFixed(1)} Wh`
                            color: Colors.text
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: Upower.availableProfiles

                    delegate: Rectangle {
                        id: profileCard
                        required property int modelData
                        readonly property bool active: Upower.currentProfile == modelData

                        radius: 8
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        implicitHeight: 40

                        color: active ? Colors.secondary : (ma.containsMouse ? Colors.overlay0 : Colors.surface1)
                        border.color: active ? Colors.secondary : Colors.surface1

                        Text {
                            anchors.centerIn: parent
                            text: PowerProfile.toString(profileCard.modelData)
                            color: active ? Colors.background1 : Colors.text
                            font.weight: Font.DemiBold
                        }

                        MouseArea {
                            id: ma
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: Upower.setProfile(profileCard.modelData)
                        }
                    }
                }
            }
        }
    }
}

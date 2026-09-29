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
                spacing: 10
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
                    text: popupBattery.batteryPercent
                    font.pixelSize: 24
                    color: Colors.text
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

                        color: active ? Colors.secondary : (ma.containsMouse ? Colors.surface2 : Colors.surface1)
                        border.color: active ? Colors.secondary : Colors.surface1

                        Text {
                            anchors.centerIn: parent
                            text: PowerProfile.toString(profileCard.modelData)
                            color: active ? Colors.background1 : Colors.text
                        }

                        MouseArea {
                            id: ma
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log(profileCard.modelData);
                                Upower.setProfile(profileCard.modelData);
                            }
                        }
                    }
                }
            }
        }
    }
}

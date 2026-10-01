import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.icons
import qs.services
import qs.components.popup.battery

RowLayout {
    id: root
    readonly property bool hasContent: batteryIcon.visible || batteryText.visible

    visible: hasContent

    property int iconSize: Config.battery.scale * 20
    property string iconColor: Config.memory.icon.color

    readonly property real batteryPercent: Upower.percentage * 100
    readonly property int lowThreshold: Config.battery.low
    readonly property int criticalThreshold: Config.battery.critical
    readonly property int suspendThreshold: Config.battery.suspend
    property bool batteryVisible: Upower.isLaptopBattery === true || Config.battery.showWhenCharging === true

    readonly property string textColor: {
        if (batteryPercent <= criticalThreshold)
            return Colors.error;
        if (batteryPercent <= lowThreshold)
            return Colors.warning;
        return Colors.text;
    }

    property bool suspendWarningSent: false

    BatteryPopup {
        id: batteryPopup
        anchorItem: root
    }

    WrapperMouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button == Qt.LeftButton) {
                batteryPopup.visible = !batteryPopup.visible;
            }
        }
        cursorShape: Qt.PointingHandCursor
    }

    BatteryIcon {
        id: batteryIcon
        visible: root.batteryVisible
        implicitHeight: root.iconSize
        implicitWidth: root.iconSize
        Layout.alignment: Qt.AlignVCenter
        percent: root.batteryPercent
        charging: {
            UPowerDeviceState.toString(Upower.state) === "Charging";
        }
        alert: root.batteryPercent < 10
        color: UPowerDeviceState.toString(Upower.state) === "Charging" ? Colors.success : Colors.text
    }

    TextBox {
        id: batteryText
        visible: root.batteryVisible
        text: `${Math.round(root.batteryPercent)}%`
    }

    Process {
        id: notifyProcess
        command: ["notify-send", "-u", "critical", "-t", "10000", "Battery Critical", "Suspending in 10 seconds"]
    }

    Process {
        id: suspendProcess
        command: ["systemctl", "suspend"]
    }

    Timer {
        id: suspendTimer
        interval: 10000
        repeat: false
        onTriggered: suspendProcess.running = true
    }

    onBatteryPercentChanged: {
        const discharging = Upower.state === Upower.discharging;

        if (discharging && batteryPercent <= suspendThreshold && !suspendWarningSent) {
            suspendWarningSent = true;
            notifyProcess.running = true;
            suspendTimer.start();
        } else if (!discharging || batteryPercent > suspendThreshold) {
            suspendWarningSent = false;
            if (suspendTimer.running)
                suspendTimer.stop();
        }
    }
}

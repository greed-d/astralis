import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.UPower
import qs.modules.common
import qs.modules.icons
import qs.services

RowLayout {
    id: root
    property int iconSize: Config.battery.scale * 20
    property string iconColor: Config.memory.icon.color

    readonly property real batteryPercent: Upower.percentage * 100
    readonly property int lowThreshold: Config.battery.low
    readonly property int criticalThreshold: Config.battery.critical
    readonly property int suspendThreshold: Config.battery.suspend

    readonly property string textColor: {
        if (batteryPercent <= criticalThreshold)
            return Colors.error;
        if (batteryPercent <= lowThreshold)
            return Colors.warning;
        return Colors.text;
    }

    property bool suspendWarningSent: false
    BatteryIcon {
        implicitHeight: root.iconSize
        implicitWidth: root.iconSize
        Layout.alignment: Qt.AlignVCenter
        percent: root.batteryPercent
        charging: Upower.state === Upower.charging
        alert: root.batteryPercent < 10
        color: root.textColor
    }

    // IconImage {
    //     source: Quickshell.iconPath(Upower.iconName)
    //     implicitHeight: root.iconSize
    //     implicitWidth: root.iconSize
    //     Layout.alignment: Qt.AlignVCenter
    // }

    TextBox {
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

import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.common
import qs.modules.icons
import qs.services

Row {
    id: root
    property int iconSize: Config.data.cpu.temperature.iconSize
    property string iconColor: Config.data.cpu.icon.color
    property string textColor: Config.data.theme.colors.textMuted
    property bool cpuTempVisible: Config.data.cpu.temperature.visible
    property bool cpuTempIconVisible: Config.data.cpu.temperature.icon

    CPUTemp {
        visible: root.cpuTempVisible
        iconSize: root.iconSize
    }
    Text {
        visible: root.cpuTempVisible
        text: `${CpuService.cpuTemperature.toFixed(1)}°C`
        color: root.textColor
    }
}

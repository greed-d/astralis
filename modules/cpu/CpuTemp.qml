import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules.common
import qs.modules.icons
import qs.services

RowLayout {
    id: root
    spacing: 0
    property int iconSize: Config.cpu.temperature.iconSize
    property bool cpuTempVisible: Config.cpu.temperature.visible
    property bool cpuTempIconVisible: Config.cpu.temperature.icon
    property real cpuTemp: CpuService.cpuTemperature.toFixed(1)
    readonly property string dynamicColor: cpuTemp < 70 ? Colors.text : Colors.error

    CPUTemp {
        visible: root.cpuTempIconVisible
        iconSize: root.iconSize
        Layout.alignment: Qt.AlignVCenter
        iconColor: root.dynamicColor
    }
    // CpuTempAlt {
    //     visible: root.cpuTempIconVisible
    //     iconSize: root.iconSize
    //     Layout.alignment: Qt.AlignVCenter
    // }
    TextBox {
        visible: root.cpuTempVisible
        color: root.dynamicColor
        Layout.alignment: Qt.AlignVCenter
        text: `${cpuTemp}°C`
    }
}

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
    property string iconColor: Config.cpu.icon.color
    property string textColor: Colors.text
    property bool cpuTempVisible: Config.cpu.temperature.visible
    property real cpuTemp: CpuService.cpuTemperature.toFixed(1)
    readonly property string dynamicColor: cpuTemp < 70 ? root.iconColor : Colors.error

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

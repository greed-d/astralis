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
    property string textColor: Config.theme.colors.text
    property bool cpuTempVisible: Config.cpu.temperature.visible
    property bool cpuTempIconVisible: Config.cpu.temperature.icon

    CPUTemp {
        visible: root.cpuTempIconVisible
        iconSize: root.iconSize
        Layout.alignment: Qt.AlignVCenter
    }
    // CpuTempAlt {
    //     visible: root.cpuTempIconVisible
    //     iconSize: root.iconSize
    //     Layout.alignment: Qt.AlignVCenter
    // }
    Text {
        visible: root.cpuTempVisible

        Layout.alignment: Qt.AlignVCenter
        text: `${CpuService.cpuTemperature.toFixed(1)}°C`
        color: root.textColor
    }
}

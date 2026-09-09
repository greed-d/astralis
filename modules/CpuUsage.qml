import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.common
import qs.modules.icons
import qs.services

Row {
    id: root
    spacing: 8 // This is here because icon and text nearly kiss
    property int iconSize: Config.cpu.icon.size
    property string iconColor: Config.cpu.icon.color
    property string textColor: Config.theme.colors.text
    property string cpuIconVisible: Config.cpu.icon.visible
    property real cpuUsage: CpuService.overallUsage

    CPUIcon {
        visible: root.cpuIconVisible
        anchors.verticalCenter: parent.verticalCenter
        iconHeight: 20
        iconColor: root.iconColor
    }
    Text {
        text: Math.round(root.cpuUsage) + "%"
        color: root.textColor
    }
}

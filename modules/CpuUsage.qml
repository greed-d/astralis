import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.common
import qs.modules.icons
import qs.services

Row {
    id: root
    spacing: 8 // This is here because icon and text nearly kiss
    property int iconSize: Config.data.cpu.icon.size
    property string iconColor: Config.data.cpu.icon.color
    property string textColor: Config.data.theme.colors.textMuted
    property real cpuUsage: CpuService.overallUsage

    CPUIcon {
        visible: root.cpuIconVisible
        anchors.verticalCenter: parent.verticalCenter
        iconHeight: 20
        iconColor: root.iconColor
    }
    Text {
        text: CpuService.overallUsage + "%"
        color: root.textColor
    }
}

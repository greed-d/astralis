import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.common
import qs.modules.icons
import qs.services

Row {
    id: root
    spacing: 5
    property int iconSize: Config.cpu.icon.size
    property string iconColor: Config.cpu.icon.color
    property string textColor: Config.theme.colors.text
    property string cpuIconVisible: Config.cpu.icon.visible
    property real cpuUsage: CpuService.overallUsage

    CPUIcon {
        id: cpuIcon
        visible: root.cpuIconVisible
        anchors.verticalCenter: parent.verticalCenter
        iconHeight: root.iconSize
        iconColor: root.iconColor
    }
    Text {
        text: Math.round(root.cpuUsage) + "%"
        color: root.textColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: -(root.iconSize * 80 / 960)
    }
}

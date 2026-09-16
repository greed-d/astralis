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
    property string cpuIconVisible: Config.cpu.icon.visible
    property real cpuUsage: CpuService.overallUsage
    readonly property string dynamicColor: root.cpuUsage < 80 ? Colors.text : Colors.error

    CPUIcon {
        id: cpuIcon
        visible: root.cpuIconVisible
        anchors.verticalCenter: parent.verticalCenter
        iconHeight: root.iconSize
        iconColor: root.dynamicColor
    }
    TextBox {
        text: Math.round(root.cpuUsage) + "%"
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: -(root.iconSize * 80 / 960)
        color: root.dynamicColor
    }
}

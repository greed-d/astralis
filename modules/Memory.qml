import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules.common
import qs.modules.icons
import qs.services

RowLayout {
    id: root
    property int iconSize: Config.memory.icon.size
    property string iconColor: Config.memory.icon.color
    property string textColor: Config.theme.colors.text

    MemoryIcon {
        iconSize: 24
    }
    Text {
        Layout.alignment: Qt.AlignVCenter
        text: (MemoryService.ramUsed ?? 0).toFixed(1)
        color: root.textColor
    }
}

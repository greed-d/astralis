import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.services

RowLayout {
    id: root

    property string textColor: Config.theme?.colors?.text ?? "#999999"

    Text {
        Layout.alignment: Qt.AlignVCenter
        text: TimeService.time
        color: root.textColor
    }
    Text {
        text: "  |  "
        Layout.alignment: Qt.AlignVCenter
        color: root.textColor
    }
    Text {
        Layout.alignment: Qt.AlignVCenter
        text: TimeService.date
        color: root.textColor
    }
}
// Text {
//     id: timeBlock
//     Layout.alignment: Qt.AlignVCenter
//     Layout.preferredWidth: timeMetrics.advanceWidth
//
//     color: Config.data.theme.colors.textMuted
//     visible: Config.data.clock.time.enabled !== false
//     verticalAlignment: Text.AlignVCenter
// }

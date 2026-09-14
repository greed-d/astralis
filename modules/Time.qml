import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.services

RowLayout {
    id: root

    property string textColor: Colors.text ?? "#cdd6f4"

    TextBox {
        Layout.alignment: Qt.AlignVCenter
        text: TimeService.time
    }
    TextBox {
        text: "  |  "
        Layout.alignment: Qt.AlignVCenter
    }
    TextBox {
        Layout.alignment: Qt.AlignVCenter
        text: TimeService.date
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

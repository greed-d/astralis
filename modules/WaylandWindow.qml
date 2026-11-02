import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.modules.icons
import qs.services
import qs.modules.common

RowLayout {
    id: root
    spacing: 8

    property string textColor: Colors.text ?? "#cdd6f4"
    property string rawAppId: WindowService.active?.appId ?? ""
    property string windowTitle: WindowService.active?.title ?? ""
    readonly property DesktopEntry appEntry: DesktopEntries.heuristicLookup(root.rawAppId)
    readonly property string activeIconPath: appEntry?.icon ?? ""

    IconImage {
        source: root.rawAppId !== "" ? Quickshell.iconPath(root.activeIconPath) : Quickshell.iconPath("user-desktop")
        implicitWidth: 20
        implicitHeight: 20
        Layout.alignment: Qt.AlignVCenter
    }

    TextBox {
        text: root.rawAppId !== "" ? root.rawAppId : "Desktop"
    }

    HoverHandler {
        id: hover
    }

    PopupWindow {
        id: popup
        visible: hover.hovered && root.windowTitle !== ""
        color: "transparent"   // default is white, that was your white panel

        anchor.item: root
        anchor.edges: Edges.Bottom     // attach to bottom edge of the module
        anchor.gravity: Edges.Bottom   // popup extends downward from that point
        anchor.rect.y: 30               // gap between module and popup
        anchor.rect.x: 50               // gap between module and popup

        implicitWidth: Math.min(label.implicitWidth + 24, 500)
        implicitHeight: label.implicitHeight + 16

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: Colors.background ?? "#1e1e2e"
            border.width: 1
            border.color: Colors.outline ?? "#45475a"

            Text {
                id: label
                anchors.centerIn: parent
                // width: parent.width - 24
                text: root.windowTitle
                color: root.textColor
                // elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}

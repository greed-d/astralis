import QtQuick
import Quickshell
import QtQuick.Layouts
import qs.services.compositor
import qs.modules.common

Item {
    id: root

    property var screen: null
    property var ws: UmbrielWorkspaceIndicatorService.workspaces
    property bool onlyActive: false

    readonly property var filteredWorkspaces: {
        const list = UmbrielWorkspaceIndicatorService.forOutput(screen ? screen.name : null);
        return onlyActive ? list.filter(w => w.occupied) : list;
    }

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout
        spacing: 6

        Repeater {
            model: root.filteredWorkspaces

            delegate: Rectangle {
                id: pill
                required property var modelData

                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                radius: 15
                color: modelData.focused ? "#89b4fa" : (modelData.active ? "#ffffff" : "#313244")

                TextBox {
                    anchors.centerIn: parent
                    text: modelData.name ?? ""
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: UmbrielWorkspaceIndicatorService.switchTo(modelData.index)
                }
            }
        }
    }
}

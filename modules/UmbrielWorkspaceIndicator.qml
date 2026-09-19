import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services.compositor
import qs.modules.common

RowLayout {
    id: root

    property var targetScreen: null

    property bool onlyActive: false

    readonly property string currentOutput: {
        if (!targetScreen)
            return "";
        return targetScreen.name !== undefined ? targetScreen.name : String(targetScreen);
    }

    readonly property var workspaceList: {
        const rawList = UmbrielWorkspaceIndicatorService.forOutput(root.currentOutput);
        if (root.onlyActive)
            return rawList.filter(w => w.active === true || w.occupied === true);
        return rawList;
    }

    spacing: 6

    Repeater {
        model: root.workspaceList

        delegate: Rectangle {
            id: wsButton
            required property var modelData
            required property int index

            readonly property bool isFocused: modelData.focused === true
            readonly property bool isActive: !wsButton.isFocused && modelData.active === true
            readonly property bool isOccupied: !wsButton.isFocused && !wsButton.isActive && modelData.occupied === true

            Layout.preferredWidth: {
                if (wsButton.isFocused)
                    return 42;
                if (wsButton.isActive)
                    return 36;
                if (wsButton.isOccupied)
                    return 28;
                return 22;
            }
            Layout.preferredHeight: 30
            radius: 18

            color: {
                if (wsButton.isFocused)
                    return Colors.primary;
                if (wsButton.isActive)
                    return Colors.secondary;
                if (wsButton.isOccupied)
                    return Colors.surface2 ?? Colors.secondary;
                return Colors.surface1;
            }

            Text {
                anchors.centerIn: parent
                text: wsButton.modelData.name ?? wsButton.modelData.index
                color: (wsButton.isFocused || wsButton.isActive) ? Colors.background0 : Colors.text
                font.pixelSize: 11
                font.bold: wsButton.isFocused || wsButton.isActive
            }

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 180
                }
            }

            WrapperMouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: UmbrielWorkspaceIndicatorService.switchTo(wsButton.modelData.index ?? wsButton.modelData.id, wsButton.modelData.output)

                onWheel: wheel => {
                    if (root.workspaceList.length === 0)
                        return;

                    const currentIdx = root.workspaceList.findIndex(w => w.active === true);
                    if (currentIdx === -1)
                        return;

                    if (wheel.angleDelta.y < 0) {
                        const nextWs = root.workspaceList[Math.min(currentIdx + 1, root.workspaceList.length - 1)];
                        UmbrielWorkspaceIndicatorService.switchTo(nextWs.index ?? nextWs.id, wsButton.modelData.output);
                    } else if (wheel.angleDelta.y > 0) {
                        const prevWs = root.workspaceList[Math.max(currentIdx - 1, 0)];
                        UmbrielWorkspaceIndicatorService.switchTo(prevWs.index ?? prevWs.id, wsButton.modelData.output);
                    }
                }
            }
        }
    }
}

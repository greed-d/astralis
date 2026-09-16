import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services.compositor
import qs.modules.common

RowLayout {
    id: root

    // Pass target screen (can be screen object or string "HDMI-A-1")
    property var targetScreen: null

    // Extract output name string safely
    readonly property string currentOutput: {
        if (!targetScreen)
            return "";
        return targetScreen.name !== undefined ? targetScreen.name : String(targetScreen);
    }

    // Filter workspaces for this specific output that are active or occupied
    readonly property var workspaceList: {
        const rawList = UmbrielWorkspaceIndicatorService.forOutput(root.currentOutput);
        return rawList.filter(w => w.active === true || w.occupied === true);
    }

    spacing: 6

    Repeater {
        model: root.workspaceList

        delegate: Rectangle {
            id: wsButton
            required property var modelData
            required property int index

            readonly property bool isFocused: modelData.active === true
            readonly property bool isOccupied: !wsButton.isFocused && modelData.occupied === true

            Layout.preferredWidth: {
                if (wsButton.isFocused)
                    return 42;
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
                return Colors.surface1;
            }

            Text {
                anchors.centerIn: parent
                text: wsButton.modelData.name ?? wsButton.modelData.index
                color: (wsButton.isFocused || wsButton.isOccupied) ? Colors.background0 : Colors.text
                font.pixelSize: 11
                font.bold: wsButton.isFocused || wsButton.isOccupied
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
                onClicked: UmbrielWorkspaceIndicatorService.switchTo(wsButton.modelData.index ?? wsButton.modelData.id)

                onWheel: wheel => {
                    if (root.workspaceList.length === 0)
                        return;

                    const currentIdx = root.workspaceList.findIndex(w => w.active === true);
                    if (currentIdx === -1)
                        return;

                    if (wheel.angleDelta.y < 0) {
                        const nextWs = root.workspaceList[Math.min(currentIdx + 1, root.workspaceList.length - 1)];
                        UmbrielWorkspaceIndicatorService.switchTo(nextWs.index ?? nextWs.id);
                    } else if (wheel.angleDelta.y > 0) {
                        const prevWs = root.workspaceList[Math.max(currentIdx - 1, 0)];
                        UmbrielWorkspaceIndicatorService.switchTo(prevWs.index ?? prevWs.id);
                    }
                }
            }
        }
    }
}

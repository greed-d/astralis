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

    property bool showIcons: true
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

            /*
             * Windows from:
             *
             *   {"event":"windows","data":[...]}
             *
             * belonging to this workspace.
             */
            readonly property var workspaceWindows: {
                if (!root.showIcons)
                    return [];

                const workspaceName = String(modelData.id ?? modelData.index);

                return (UmbrielWorkspaceIndicatorService.windows ?? []).filter(w => String(w.workspace) === workspaceName).sort((a, b) => {
                    if (a.y === b.y) {
                        return a.x - b.x;
                    }

                    return a.y - b.y;
                });
            }

            Layout.preferredWidth: Math.max(minWidth, contentRow.implicitWidth + 24)
            readonly property int minWidth: {
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
            color: "transparent"

            border.color: {
                if (wsButton.isFocused)
                    return Colors.textDisabled;

                if (wsButton.isActive)
                    return Colors.secondary;

                if (wsButton.isOccupied)
                    return Colors.surface2 ?? Colors.secondary;

                return Colors.surface1;
            }

            border.width: {
                if (wsButton.isFocused || wsButton.isActive)
                    return 2;

                return 1;
            }
            RowLayout {
                id: contentRow
                anchors.centerIn: parent
                spacing: 12
                z: 1

                Text {
                    text: wsButton.modelData.name ?? wsButton.modelData.index
                    color: (wsButton.isFocused || wsButton.isActive) ? Colors.info : Colors.warning
                    font.pixelSize: 11
                    font.bold: wsButton.isFocused || wsButton.isActive
                }

                Repeater {
                    model: root.showIcons ? wsButton.workspaceWindows : []

                    delegate: Item {
                        id: iconWrapper

                        required property var modelData

                        readonly property bool windowFocused: iconWrapper.modelData.focused === true
                        readonly property string rawAppId: iconWrapper.modelData.app_id ?? ""
                        readonly property DesktopEntry appEntry: rawAppId !== "" ? DesktopEntries.heuristicLookup(rawAppId) : null
                        readonly property string iconName: appEntry?.icon ?? rawAppId

                        width: 22
                        height: 22

                        IconImage {
                            anchors.fill: parent
                            smooth: true
                            source: iconWrapper.rawAppId !== "" ? Quickshell.iconPath(iconWrapper.iconName, "application-x-executable") : Quickshell.iconPath("user-desktop")
                        }

                        // dim overlay for unfocused windows
                        Rectangle {
                            anchors.fill: parent
                            radius: 4
                            color: Colors.surface0
                            opacity: iconWrapper.windowFocused ? 0 : 0.4

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }

                        WrapperMouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["umbriel", "msg", "window-focus:" + iconWrapper.modelData.id])
                        }
                    }
                }
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

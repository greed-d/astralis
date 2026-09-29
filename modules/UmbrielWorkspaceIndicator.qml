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
                // console.log(JSON.stringify(UmbrielWorkspaceIndicatorService.windows, null, 2));
                // console.log("Workspace Name : ", modelData.id);

                return (UmbrielWorkspaceIndicatorService.windows ?? []).filter(w => String(w.workspace) === workspaceName).sort((a, b) => {
                    // Same row: left → right.
                    if (a.y === b.y) {
                        // console.log("Position X : ", a.x - b.x);
                        return a.x - b.x;
                    }

                    // Different rows: top → bottom.
                    return a.y - b.y;
                });
            }

            // Layout.preferredWidth: {
            //     if (wsButton.isFocused)
            //         return 42;
            //
            //     if (wsButton.isActive)
            //         return 36;
            //
            //     if (wsButton.isOccupied)
            //         return 28;
            //
            //     return 22;
            // }

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
                if (wsButton.isFocused)
                    return 2;

                if (wsButton.isActive)
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

                        width: 22
                        height: 22

                        // Component.onCompleted: {
                        //     console.log("ModelData:", JSON.stringify(modelData, null, 2));
                        // }

                        Rectangle {

                            anchors.fill: parent
                            color: "transparent"
                            IconImage {
                                anchors.fill: parent
                                source: Quickshell.iconPath(iconWrapper.modelData.app_id)
                                smooth: true
                            }
                            WrapperMouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Quickshell.execDetached(["umbriel", "msg", "window-focus:" + iconWrapper.modelData.id])
                                // onClicked: {
                                //     console.log("Clicked : ", modelData.app_id);
                                // }
                            }
                        }

                        // Whiteish overlay for unfocused windows.
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
                    }
                }
            }

            // Row {
            //     anchors.centerIn: parent
            //     spacing: 2
            //
            //     /*
            //      * Window icons
            //      */
            //     Repeater {
            //         model: root.showIcons ? wsButton.workspaceWindows : []
            //
            //         delegate: Image {
            //             required property var modelData
            //
            //             width: 18
            //             height: 18
            //
            //             source: Quickshell.iconPath(modelData.app_id)
            //
            //             fillMode: Image.PreserveAspectFit
            //             smooth: true
            //         }
            //     }
            //
            //     /*
            //      * Fall back to workspace number when:
            //      *
            //      *   showIcons == false
            //      *
            //      * or there are no windows.
            //      */
            //     Text {
            //         visible: !root.showIcons || wsButton.workspaceWindows.length === 0
            //
            //         text: wsButton.modelData.name ?? wsButton.modelData.index
            //
            //         color: (wsButton.isFocused || wsButton.isActive) ? Colors.info : Colors.warning
            //
            //         font.pixelSize: 11
            //
            //         font.bold: wsButton.isFocused || wsButton.isActive
            //     }
            // }

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

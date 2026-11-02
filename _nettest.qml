import QtQuick
import Quickshell
import qs.modules.common

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 40
        color: Colors.background0

        Rectangle {
            id: anchorItem
            x: 400
            y: 5
            width: 60
            height: 30
            color: Colors.surface0
        }

        PopupWindow {
            id: popup
            property bool open: false
            property Item anchorItem: null

            visible: open
            color: "transparent"
            implicitWidth: 300
            implicitHeight: 120
            anchor.item: anchorItem
            anchor.rect.x: 0
            anchor.rect.y: 30

            Rectangle {
                anchors.fill: parent
                color: Colors.background2

                TextInput {
                    id: ti
                    anchors.fill: parent
                    anchors.margins: 10
                    color: Colors.text
                    focus: true
                    onActiveFocusChanged: console.log("TI activeFocus ->", activeFocus)
                }
            }
        }
    }

    Timer {
        interval: 400
        running: true
        repeat: true
        property int n: 0
        onTriggered: {
            n++;
            if (n === 2) {
                console.log("OPEN (no grabFocus)");
                popup.open = true;
                Qt.callLater(() => ti.forceActiveFocus());
            } else if (n === 4) {
                console.log("CHECK activeFocus=", ti.activeFocus, "focus=", ti.focus);
                ti.text = "hello";
                console.log("TEXT=", ti.text);
            } else if (n === 6) {
                console.log("DONE open=", popup.open, "visible=", popup.visible, "focus=", ti.activeFocus);
                Qt.quit();
            }
        }
    }
}

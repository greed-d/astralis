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
    property string textColor: Config.theme?.colors?.text ?? "#ffffff"
    property string rawAppId: WindowService.active?.appId ?? ""
    readonly property DesktopEntry appEntry: DesktopEntries.heuristicLookup(root.rawAppId)
    readonly property string activeIconPath: appEntry?.icon ?? ""

    // --- DEBUG LOGGERS ---
    // onRawAppIdChanged: {
    //     console.log("----------------------------------------");
    //     console.log("[DEBUG] rawAppId:", rawAppId);
    // }
    //
    // onAppEntryChanged: {
    //     if (appEntry) {
    //         console.log("[DEBUG] appEntry.id:", appEntry.id);
    //         console.log("[DEBUG] appEntry.name:", appEntry.name);
    //         console.log("[DEBUG] appEntry.icon:", appEntry.icon);
    //         console.log("[DEBUG] appEntry.exec:", appEntry.exec);
    //     } else {
    //         console.log("[DEBUG] appEntry: null (No match found)");
    //     }
    // }
    //
    // onActiveIconPathChanged: {
    //     console.log("[DEBUG] activeIconPath:", activeIconPath);
    //     console.log("[DEBUG] Quickshell.iconPath():", Quickshell.iconPath(activeIconPath));
    // }
    // ---------------------

    IconImage {
        source: Quickshell.iconPath(activeIconPath)
        implicitWidth: 20
        implicitHeight: 20
        Layout.preferredWidth: 20
        Layout.preferredHeight: 20
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        text: WindowService.active?.appId ?? ""
        color: root.textColor
    }
}

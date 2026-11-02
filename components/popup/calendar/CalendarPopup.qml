import QtQuick
import Quickshell
import qs.services
import qs.widgets

PopupWindow {
    id: popup
    required property Item anchorItem

    anchor.item: anchorItem
    anchor.rect.x: (anchorItem.width - width) / 2
    anchor.rect.y: anchorItem.height + 6        // bar at bottom: -height - 6
    anchor.adjustment: PopupAdjustment.Slide    // keep on-screen near edges

    implicitWidth: cal.implicitWidth
    implicitHeight: cal.implicitHeight
    color: "transparent"
    visible: false

    onVisibleChanged: if (visible)
        CalendarService.goToday()

    CalendarWidget {
        id: cal
    }
}

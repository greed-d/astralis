pragma Singleton

import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    id: root

    property string timeFormat: Config.clock?.time?.format ?? "hh:mm"
    property string dateFormat: Config.clock?.date?.format ?? "yyyy-MM-dd"

    // Bind dynamically to clock.date
    readonly property string time: Qt.formatDateTime(clock.date, root.timeFormat)
    readonly property string date: Qt.formatDateTime(clock.date, root.dateFormat)

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}

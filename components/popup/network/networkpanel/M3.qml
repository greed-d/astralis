pragma Singleton

import Quickshell
import QtQuick
import qs.modules.common

Singleton {
    readonly property color surface: Colors.background2
    readonly property color content: Colors.text
    readonly property color contentVariant: Colors.overlay2
    readonly property color outline: Colors.border
    readonly property color primary: "#8ab4f8"      // map to your palette
    readonly property color primaryContent: "#0b1b33"
    readonly property color primaryContainer: Qt.alpha(primary, 0.22)
    readonly property color surfaceHigh: Qt.alpha(content, 0.07)
    readonly property color error: "#f2b8b5"
}

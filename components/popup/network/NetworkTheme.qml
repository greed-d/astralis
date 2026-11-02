pragma Singleton

// Material 3 Expressive style tokens for the network popup, mapped onto the
// project's `Colors` palette so the popup follows the active theme.
import Quickshell
import QtQuick
import qs.modules.common

Singleton {
    // ---- Surfaces -------------------------------------------------------
    readonly property color surface: Colors.background2
    readonly property color surfaceContainerLowest: Colors.background0
    readonly property color surfaceContainerLow: Colors.background1
    readonly property color surfaceContainer: Qt.tint(Colors.background2, Qt.alpha(Colors.text, 0.03))
    readonly property color surfaceContainerHigh: Qt.tint(Colors.background2, Qt.alpha(Colors.text, 0.06))
    readonly property color surfaceContainerHighest: Qt.tint(Colors.background2, Qt.alpha(Colors.text, 0.11))
    readonly property color surfaceVariant: Colors.surface0

    // ---- Content --------------------------------------------------------
    // Main text and smaller/secondary text follow the shared palette.
    readonly property color onSurface: Colors.text
    readonly property color onSurfaceVariant: Colors.subtext
    readonly property color onSurfaceFaint: Qt.alpha(Colors.subtext, 0.65)

    // ---- Typography -----------------------------------------------------
    // Proportional font from the global config (same source the bar uses,
    // see modules/common/TextBox.qml).
    readonly property string fontFamily: Config.theme.font.family

    // ---- Outline --------------------------------------------------------
    readonly property color outline: Colors.border
    readonly property color outlineVariant: Colors.borderMuted

    // ---- Primary --------------------------------------------------------
    readonly property color primary: Colors.primary
    readonly property color onPrimary: Colors.background0
    readonly property color primaryContainer: Qt.tint(Colors.background2, Qt.alpha(Colors.primary, 0.22))
    readonly property color onPrimaryContainer: Colors.primary
    // Stronger tonal surface for filled accents (buttons, switches, icon
    // tiles): blue-tinted dark background with blue content, instead of
    // dark-on-blue text which reads poorly.
    readonly property color primaryContainerStrong: Qt.tint(Colors.background2, Qt.alpha(Colors.primary, 0.32))

    // ---- Secondary ------------------------------------------------------
    readonly property color secondaryContainer: Qt.tint(Colors.background2, Qt.alpha(Colors.secondary, 0.18))
    readonly property color onSecondaryContainer: Colors.secondary

    // ---- Semantic -------------------------------------------------------
    readonly property color error: Colors.error
    readonly property color onError: Colors.background0
    readonly property color errorContainer: Qt.tint(Colors.background2, Qt.alpha(Colors.error, 0.18))
    readonly property color success: Colors.success
    readonly property color warning: Colors.warning

    // ---- Shape / motion -------------------------------------------------
    readonly property int radiusSmall: 12
    readonly property int radiusMedium: 18
    readonly property int radiusLarge: 26
    readonly property int radiusFull: 999

    readonly property int motionFast: 120
    readonly property int motionMedium: 200
    readonly property int motionSlow: 320
}

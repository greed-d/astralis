pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    FileView {
        path: Quickshell.shellPath("colors.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property string background0: "#11111b"
            property string background1: "#181825"
            property string background2: "#1e1e2e"

            property string surface0: "#313244"
            property string surface1: "#45475a"
            property string surface2: "#585b70"

            property string text: "#cdd6f4"
            property string textMuted: "#bac2de"
            property string textDisabled: "#a6adc8"

            property string primary: "#89b4fa"
            property string secondary: "#b4befe"

            property string success: "#a6e3a1"
            property string warning: "#f9e2af"
            property string error: "#f38ba8"
            property string info: "#89dceb"

            property string border: "#45475a"
            property string borderMuted: "#313244"

            property string overlay0: "#6c7086"
            property string overlay1: "#7f849c"
            property string overlay2: "#9399b2"
        }
    }

    readonly property alias background0: adapter.background0
    readonly property alias background1: adapter.background1
    readonly property alias background2: adapter.background2

    readonly property alias surface0: adapter.surface0
    readonly property alias surface1: adapter.surface1
    readonly property alias surface2: adapter.surface2

    readonly property alias text: adapter.text
    readonly property alias textMuted: adapter.textMuted
    readonly property alias textDisabled: adapter.textDisabled

    readonly property alias primary: adapter.primary
    readonly property alias secondary: adapter.secondary

    readonly property alias success: adapter.success
    readonly property alias warning: adapter.warning
    readonly property alias error: adapter.error
    readonly property alias info: adapter.info

    readonly property alias border: adapter.border
    readonly property alias borderMuted: adapter.borderMuted

    readonly property alias overlay0: adapter.overlay0
    readonly property alias overlay1: adapter.overlay1
    readonly property alias overlay2: adapter.overlay2
}

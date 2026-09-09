pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    property var data: adapter

    FileView {
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        blockLoading: true

        //HACK: needed to read workspaces.maxCount from `config.toml?`
        // preload: false
        JsonAdapter {
            id: adapter

            // Global theme. Source of default and base values for all components.
            property JsonObject theme: JsonObject {
                property JsonObject colors: JsonObject {
                    property string text: "#999999"
                    property string textMuted: "#777777"
                    property string foreground: "#999999"
                    property string foreground2: "#777777"
                    property string background: "#222222"
                    property string background2: "#666666"
                    property string ok: "#1A7F39"
                    property string error: "#E5002E"
                    property string warning: "#E5BF00"
                }
                // Proportional font
                property JsonObject font: JsonObject {
                    property string family: "Sans"
                    // Size in pixels of all proportional fonts. The actual size
                    // of fonts in individual components will be proportional to
                    // this value.
                    property real size: 14
                }
                // Monospace font
                property JsonObject fontMono: JsonObject {
                    property string family: "Monospace"
                    // Size in pixels of all monospace fonts. The actual size of
                    // fonts in individual components will be proportional to
                    // this value.
                    property real size: 14
                }
                property JsonObject widget: JsonObject {
                    // Size in pixels of all widgets. The actual size of
                    // individual widgets will be proportial to this value.
                    property real size: 24
                }
            }

            // Defines the widgets that should be shown in each section and their order.
            property JsonObject layout: JsonObject {
                property JsonObject left: JsonObject {
                    property list<string> widgets: ["workspaces", "focusedWindow"]
                    property bool separator: true
                    property int spacing: 6
                }
                property JsonObject center: JsonObject {
                    property list<string> widgets: []
                    property bool separator: true
                    property int spacing: 6
                }
                property JsonObject right: JsonObject {
                    property list<string> widgets: ["cpu", "ram", "network", "battery", "clock"]
                    property bool separator: true
                    property int spacing: 6
                }
            }

            property JsonObject cpu: JsonObject {
                property real scale: 1
                property int updateInterval: 1000
                property int numTopProcesses: 10
                property JsonObject temperature: JsonObject {
                    property bool visible: true
                    property bool icon: true
                    property int iconSize: 20
                }
                property JsonObject icon: JsonObject {
                    property bool visible: false
                    property bool enabled: true
                    property real scale: 1
                    property real size: 24
                    property string color: "#777777" // Need to change this in future
                }
            }

            property JsonObject bar: JsonObject {
                property string position: Types.positionToString(Types.Position.Top)
                property int size: 30
            }
            property JsonObject network: JsonObject {
                property real scale: 1
                property int externalUpdateInterval: 1000
                property JsonObject icon: JsonObject {
                    property bool visible: true
                    property bool enabled: true
                    property real scale: 1
                    property string color: "black" // Need to change this in future
                }
            }
        }
    }
}

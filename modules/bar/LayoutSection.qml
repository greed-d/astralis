import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common

RowLayout {
    id: root
    required property string section
    property var widgetComponents
    spacing: Config.layout[section]?.spacing || 0

    readonly property var widgetModel: {
        let model = [];
        let hasPreviousWidget = false;
        const widgets = Config.layout[section]?.widgets || [];
        const useSeparator = Config.layout[section]?.separator || false;

        for (let i = 0; i < widgets.length; i++) {
            const widget = widgetComponents[widgets[i]];
            if (!widget) {
                console.error(`[ERROR] Invalid Widget : ${widgets[i]}`);
                continue;
            }

            if (useSeparator && hasPreviousWidget) {
                model.push(widgetComponents["separator"]);
            }
            model.push(widget);
            hasPreviousWidget = true;
        }
        return model;
    }

    Repeater {
        model: root.widgetModel
        delegate: Loader {
            active: true
            sourceComponent: modelData
        }
    }
}

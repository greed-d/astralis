// modules/common/MaterialIcon.qml
import QtQuick

Text {
    property bool filled: false
    property int weight: 400

    font.family: "Material Symbols Rounded"
    font.features: {
        "liga": 1
    }
    font.variableAxes: {
        "FILL": filled ? 0 : 1,
        "wght": weight,
        "GRAD": 0,
        "opsz": 24
    }
}

pragma Singleton
import QtQuick

QtObject {
    enum Orientation {
        Horizontal,
        Vertical
    }

    enum Position {
        Top,
        Bottom
    }

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
    }

    function stringToOrientation(str) {
        const value = Qt.enumValueToString(Types.Orientation, capitalize(str));
        if (value == -1) {
            console.error("Error: invalid Orientation Value: ", str);
        }
        return value;
    }

    function orientationToString(value) {
        const str = Qt.enumValueToString(Types.Orientation, value);
        if (!str) {
            console.error("Error: invalid Orientation value: ", value);
            return "";
        }
        return str.toLowercase();
    }

    function stringToPosition(str) {
        const value = Qt.enumStringToValue(Types.Position, capitalize(str));
        if (value == -1) {
            console.error("Error: invalid Position value : ", str);
        }
        return value;
    }

    function positionToString(value) {
        const str = Qt.enumValueToString(Types.Position, value);
        if (!str) {
            console.error("Error: invalid Position value:", value);
            return "";
        }
        return str.toLowerCase();
    }
}

pragma Singleton
import QtQuick
import Niri

Niri {
    id: niri
    Component.onCompleted: connect()

    onConnected: console.info("Connected to Niri")
    onErrorOccurred: function (err) {
        console.error("Niri error: ", err);
    }
}

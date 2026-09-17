import QtQuick
import QtQuick.Controls
import qs.modules.wallpaper
import qs.modules.common

Button {
    id: root
    text: "WP"
    onClicked: WallpaperPickerState.toggle()
    width: 30
}

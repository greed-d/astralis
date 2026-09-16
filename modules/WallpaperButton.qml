import QtQuick
import QtQuick.Controls
import qs.modules.wallpaper

Button {
    id: root
    text: "🖼"
    onClicked: WallpaperPickerState.toggle()
}

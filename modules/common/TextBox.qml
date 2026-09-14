import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common

Text {
    id: textBox
    readonly property var fontConfig: Config.theme.font
    property string fontFamily: fontConfig.family
    property string fontSize: fontConfig.size

    property string textColor: Colors.text ?? "#ffffff"

    color: textColor
    font.family: fontFamily
    font.pixelSize: fontSize
    font.weight: Font.DemiBold

    Layout.alignment: Qt.AlignVCenter
}

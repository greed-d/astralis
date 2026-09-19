import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.modules.common

Rectangle {
    id: card
    property string summary: ""
    property string body: ""
    property url image: ""
    property url appIcon: ""
    property int urgency: NotificationUrgency.Normal
    property string timeText: ""
    signal dismissed

    implicitWidth: 300
    implicitHeight: layout.implicitHeight + 20
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    radius: 8
    color: Colors.background0
    border {
        width: 2
        color: urgency === NotificationUrgency.Critical ? Colors.error : Colors.primary
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        Image {
            Layout.preferredHeight: 36
            Layout.preferredWidth: 36
            Layout.alignment: Qt.AlignTop
            visible: source.toString() !== ""
            source: card.image || card.appIcon || ""
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            TextBox {
                Layout.fillWidth: true
                text: card.summary
                font.bold: true
                elide: Text.ElideRight
                color: Colors.info
                fontSize: Config.theme.font.size + 1
            }
            TextBox {
                Layout.fillWidth: true
                text: card.body
                visible: text !== ""
                wrapMode: Text.WordWrap
                fontSize: Config.theme.font.size - 1
            }
            TextBox {
                visible: card.timeText !== ""
                text: card.timeText
                fontSize: Config.theme.font.size - 2
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: card.dismissed()
    }
}

// NotificationCard.qml
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
    property var actions: []   // list of NotificationAction — only meaningful for live notifications
    signal dismissed
    signal closeClicked

    implicitWidth: 300
    implicitHeight: layout.implicitHeight + 20
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight
    radius: 8
    color: Colors.background2
    border {
        width: 1
        color: urgency === NotificationUrgency.Critical ? Colors.error : Colors.primary
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Image {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 36
                Layout.alignment: Qt.AlignVCenter
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
                    color: Colors.textMuted
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignTop

                TextBox {
                    visible: card.timeText !== ""
                    text: card.timeText
                    fontSize: Config.theme.font.size - 2
                    color: Colors.textMuted
                }
                TextBox {
                    Layout.alignment: Qt.AlignTop
                    text: "×"
                    font.bold: true
                    fontSize: Config.theme.font.size + 2
                    color: Colors.textMuted
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        onClicked: card.closeClicked()
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: card.actions.length > 0
            Layout.alignment: Qt.AlignCenter

            Repeater {
                model: card.actions
                delegate: Rectangle {
                    required property var modelData
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: actionLabel.implicitWidth + 20
                    radius: 6
                    color: Colors.background2
                    TextBox {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: modelData.text
                        fontSize: Config.theme.font.size - 1
                        color: Colors.text
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.invoke()
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: card.dismissed()
    }
}

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
    property var actions: []
    property var actionRows: []
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

    FontMetrics {
        id: actionFontMetrics
        font.pixelSize: Config.theme.font.size - 1
    }

    function computeActionRows() {
        const maxWidth = card.implicitWidth - 20; // match layout margins
        const spacing = 6;
        const hPadding = 20; // horizontal padding inside each button

        let rows = [];
        let row = [];
        let rowWidth = 0;

        for (let i = 0; i < card.actions.length; i++) {
            const action = card.actions[i];
            const btnWidth = actionFontMetrics.advanceWidth(action.text) + hPadding;
            const add = row.length > 0 ? btnWidth + spacing : btnWidth;

            if (rowWidth + add > maxWidth && row.length > 0) {
                rows.push(row);
                row = [action];
                rowWidth = btnWidth;
            } else {
                row.push(action);
                rowWidth += add;
            }
        }
        if (row.length > 0)
            rows.push(row);
        card.actionRows = rows;
    }

    onActionsChanged: computeActionRows()
    Component.onCompleted: computeActionRows()

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

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: card.actions.length > 0

            Repeater {
                model: card.actionRows
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 6

                    Repeater {
                        model: modelData
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            radius: 6
                            color: Colors.surface1
                            border {
                                width: 1
                                color: Colors.surface1
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.topMargin: 2
                                radius: 6
                                color: "#40000000"
                                z: -1
                            }

                            TextBox {
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
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: card.dismissed()
    }
}

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.modules.common
import qs.modules.icons
import qs.services
import qs.components.progressbar

PopupWindow {
    id: popupMpris
    property Item anchorItem: null

    implicitWidth: 340
    implicitHeight: 340

    anchor.item: anchorItem
    anchor.rect.x: anchorItem ? (anchorItem.width / 2 - implicitWidth / 2) : 0
    anchor.rect.y: anchorItem ? anchorItem.height + 12 : 0

    color: "transparent"

    // translucent round button used for prev/play/next
    component GlassButton: Rectangle {
        id: btn
        property int size: 44
        property bool enabledButton: true
        default property alias content: holder.data
        signal clicked

        implicitWidth: size
        implicitHeight: size
        radius: size / 2
        color: Qt.rgba(0, 0, 0, mouse.containsMouse ? 0.55 : 0.4)
        opacity: enabledButton ? 1 : 0.4

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }

        Item {
            id: holder
            anchors.fill: parent
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: btn.enabledButton
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.clicked()
        }
    }

    // outer bezel
    Rectangle {
        anchors.fill: parent
        radius: 32
        color: Colors.background2

        // inner card, art fills it
        ClippingRectangle {
            id: card
            anchors.fill: parent
            anchors.margins: 8
            radius: 26
            color: Colors.surface0

            Image {
                id: art
                anchors.fill: parent
                source: MprisService.artUrl ? MprisService.artUrl : ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                visible: status === Image.Ready
            }

            NoMedia {
                visible: art.status !== Image.Ready
                anchors.centerIn: parent
                iconSize: 96
                fillColor: Colors.textMuted
            }

            // bottom scrim for legibility
            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: 170
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "transparent"
                    }
                    GradientStop {
                        position: 1.0
                        color: Qt.rgba(0, 0, 0, 0.65)
                    }
                }
            }

            // top-left info pill
            Rectangle {
                id: pill
                anchors {
                    top: parent.top
                    left: parent.left
                    margins: 12
                }
                height: 52
                width: Math.min(pillRow.implicitWidth + 20, parent.width - 24)
                radius: height / 2
                color: Qt.rgba(0, 0, 0, 0.45)

                RowLayout {
                    id: pillRow
                    anchors {
                        fill: parent
                        leftMargin: 6
                        rightMargin: 14
                        topMargin: 6
                        bottomMargin: 6
                    }
                    spacing: 10

                    ClippingRectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        Layout.alignment: Qt.AlignVCenter
                        radius: 20
                        color: Colors.surface0

                        Image {
                            anchors.fill: parent
                            source: MprisService.artUrl ? MprisService.artUrl : ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            visible: status === Image.Ready
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 0

                        TextBox {
                            Layout.fillWidth: true
                            text: MprisService.title
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: "white"
                            elide: Text.ElideRight
                        }
                        TextBox {
                            Layout.fillWidth: true
                            text: MprisService.artist ? MprisService.artist : "No artist"
                            font.pixelSize: 13
                            color: Qt.rgba(1, 1, 1, 0.65)
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            // progress + controls
            ColumnLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 14
                }
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true

                    TextBox {
                        text: MprisService.positionText
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        color: "white"
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    TextBox {
                        text: MprisService.lengthText
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        color: Qt.rgba(1, 1, 1, 0.75)
                    }
                }

                ProgressComponent {
                    Layout.fillWidth: true
                    indeterminate: false
                    progressBarWidth: 10
                    value: MprisService.length > 0 ? MprisService.position / MprisService.length : 0
                    fillColor: "white"
                    fillBarBackground: Qt.rgba(30, 30, 46, 0.25)
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 6
                    spacing: 14

                    GlassButton {
                        size: 44
                        enabledButton: MprisService.canGoPrevious
                        onClicked: MprisService.previous()

                        PrevIcon {
                            anchors.centerIn: parent
                            iconSize: 20
                            fillColor: Colors.text
                        }
                    }

                    GlassButton {
                        size: 52
                        enabledButton: MprisService.canPlay || MprisService.canPause
                        onClicked: MprisService.togglePlaybackState()

                        PlayIcon {
                            anchors.centerIn: parent
                            visible: !MprisService.isPlaying
                            iconSize: 26
                            fillColor: Colors.text
                        }
                        PauseIcon {
                            anchors.centerIn: parent
                            visible: MprisService.isPlaying
                            iconSize: 26
                            fillColor: Colors.text
                        }
                    }

                    GlassButton {
                        size: 44
                        enabledButton: MprisService.canGoNext
                        onClicked: MprisService.next()

                        NextIcon {
                            anchors.centerIn: parent
                            iconSize: 20
                            fillColor: Colors.text
                        }
                    }
                }
            }
        }
    }
}

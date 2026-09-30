import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
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

    implicitWidth: 350
    implicitHeight: col.implicitHeight + 24

    anchor.item: anchorItem

    anchor.rect.x: anchorItem ? (anchorItem.width / 2 - implicitWidth / 2) : 0
    anchor.rect.y: anchorItem ? anchorItem.height + 6 : 0

    color: "transparent"

    Rectangle {
        color: Colors.background2
        anchors.fill: parent
        implicitHeight: col.implicitHeight
        radius: 12

        ColumnLayout {
            id: col
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 8
            RowLayout {
                spacing: 16
                ClippingWrapperRectangle {
                    id: clipRect
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 80
                    Layout.preferredWidth: 80
                    radius: 20
                    color: Colors.surface0

                    Item {
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
                            iconSize: 50
                            fillColor: Colors.textMuted
                        }
                    }
                }
                ColumnLayout {
                    spacing: 0
                    TextBox {
                        text: MprisService.playerName
                        font.pixelSize: 16
                        color: Colors.overlay2
                    }
                    TextBox {
                        text: MprisService.title
                        font.pixelSize: 24
                        font.weight: Font.DemiBold
                        Layout.preferredWidth: -1
                        Layout.maximumWidth: popupMpris.implicitWidth - clipRect.width - 30
                        elide: Text.ElideRight           // truncate visually instead of overflowing
                    }
                    TextBox {
                        text: MprisService.artist ? MprisService.artist : "No artist"
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                        color: Colors.overlay0
                        Layout.preferredWidth: -1
                        Layout.maximumWidth: popupMpris.implicitWidth - clipRect.width - 30
                        elide: Text.ElideRight           // truncate visually instead of overflowing
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                TextBox {
                    id: post
                    text: MprisService.positionText
                    font.weight: Font.DemiBold
                    Layout.preferredWidth: 60
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignVCenter
                }
                ProgressComponent {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    indeterminate: false
                    value: MprisService.length > 0 ? MprisService.position / MprisService.length : 0
                    fillColor: Colors.primary
                    fillBarBackground: Colors.surface0
                }
                TextBox {
                    text: MprisService.lengthText
                    font.weight: Font.DemiBold

                    Layout.preferredWidth: 60
                    horizontalAlignment: Text.AlignHCenter

                    Layout.alignment: Qt.AlignVCenter
                }
                Component.onCompleted: {
                    console.log("Position text width", post.width);
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 16

                MediaButton {
                    size: 40
                    enabledButton: MprisService.canGoPrevious
                    onClicked: MprisService.previous()

                    content: PrevIcon {
                        anchors.centerIn: parent
                        fillColor: Colors.text
                        iconSize: 20
                    }
                }

                MediaButton {
                    size: 64
                    primary: true
                    enabledButton: MprisService.canPlay || MprisService.canPause
                    onClicked: MprisService.togglePlaybackState()

                    content: Item {
                        anchors.fill: parent

                        PlayIcon {
                            anchors.centerIn: parent
                            visible: !MprisService.isPlaying
                            iconSize: 32
                            fillColor: Colors.background2
                        }
                        PauseIcon {
                            anchors.centerIn: parent
                            visible: MprisService.isPlaying
                            iconSize: 32
                            fillColor: Colors.background2
                        }
                    }
                }

                MediaButton {
                    size: 40
                    enabledButton: MprisService.canGoNext
                    onClicked: MprisService.next()

                    content: NextIcon {
                        anchors.centerIn: parent
                        fillColor: Colors.text
                        iconSize: 20
                    }
                }
            }
        }
    }
}

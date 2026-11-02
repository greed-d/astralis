import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: root
    implicitWidth: 280
    implicitHeight: col.implicitHeight + 24
    color: "#1e1e2e"
    radius: 12

    // re-evaluate on any view change
    property var model: {
        CalendarService.viewYear;
        CalendarService.viewMonth;
        CalendarService.bs;
        return CalendarService.cells();
    }

    ColumnLayout {
        id: col
        anchors {
            fill: parent
            margins: 12
        }
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "‹"
                color: "white"
                font.pixelSize: 18
                MouseArea {
                    anchors.fill: parent
                    onClicked: CalendarService.step(-1)
                }
            }
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.bold: true
                text: (CalendarService.bs ? CalendarService.bsMonths : CalendarService.adMonths)[CalendarService.viewMonth] + " " + CalendarService.viewYear
                MouseArea {
                    anchors.fill: parent
                    onClicked: CalendarService.goToday()
                }
            }
            Text {
                text: "›"
                color: "white"
                font.pixelSize: 18
                MouseArea {
                    anchors.fill: parent
                    onClicked: CalendarService.step(1)
                }
            }
            Rectangle {
                implicitWidth: 40
                implicitHeight: 22
                radius: 6
                color: "#313244"
                Text {
                    anchors.centerIn: parent
                    color: "#cba6f7"
                    font.bold: true
                    text: CalendarService.bs ? "BS" : "AD"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: CalendarService.toggle()
                }
            }
        }

        GridLayout {
            columns: 7
            Layout.fillWidth: true
            rowSpacing: 2
            columnSpacing: 2
            Repeater {
                model: ["S", "M", "T", "W", "T", "F", "S"]
                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    color: index === 6 ? "#f38ba8" : "#a6adc8"
                }
            }
            Repeater {
                model: root.model
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 34
                    radius: 6
                    color: modelData.today ? "#cba6f7" : "transparent"
                    opacity: modelData.inMonth ? 1 : 0.3
                    Column {
                        anchors.centerIn: parent
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.day
                            font.pixelSize: 13
                            color: modelData.today ? "#1e1e2e" : "white"
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.alt
                            font.pixelSize: 8
                            color: modelData.today ? "#1e1e2e" : "#6c7086"
                        }
                    }
                }
            }
        }
    }
}

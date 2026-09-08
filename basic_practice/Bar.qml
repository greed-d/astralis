import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text

Scope {
    Variants {
        model: Quickshell.screens // get screen data from QS
        PanelWindow {

            // screenlist will injected to this var
            required property var modelData
            // set the window's screen to injected property
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            ClockWidget {
                anchors.centerIn: parent
            }
        }
    }
}

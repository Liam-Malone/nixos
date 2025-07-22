import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  Time { id: timeSource }

  Variants {
    model: Quickshell.screens;
  
    PanelWindow {
      property var modelData
      screen: modelData
  
      anchors {
        top: true
        left: true
        right: true
      }
    
      implicitHeight: 24
    
      Clock {
          anchors.centerIn: parent
          time: timeSource.time
      }
    }
  }
}

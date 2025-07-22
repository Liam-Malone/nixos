import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string time

  Process {
    id: dateProc
    command: [ "date", "+%T | %A, %b %d | %Y" ]
    running: true
  
    stdout: StdioCollector {
      onStreamFinished: root.time = this.text
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}

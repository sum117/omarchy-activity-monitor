import QtQuick
import QtQuick.Window
import QtTest

Window {
  width: 420; height: 220; visible: true
  Timer {
    interval: 200; running: true
    onTriggered: {
      try { checks.runChecks(); console.log("FORK_UI_PASS") }
      catch (e) { console.error("FORK_UI_FAIL", e) }
      Qt.quit()
    }
  }
  TestCase {
    id: checks
    when: false
    visible: true
    width: 420; height: 220
    HeaderAction { id: action; glyph: "󰒓"; tooltipBounds: checks; helpText: "Activity settings" }
    SignalSpy { id: clicked; target: action; signalName: "clicked" }
    ProcessActionController { id: actions; active: true }
    function check(value, message) { if (!value) throw new Error(message) }
    function runChecks() {
      mouseClick(action, action.width / 2, action.height / 2, Qt.LeftButton)
      check(clicked.count === 1, "header click")
      action.forceActiveFocus()
      keyClick(Qt.Key_Space)
      check(clicked.count === 2, "header keyboard activation")
      var glyph = findChild(action, "centeredGlyph")
      for (var icon of ["󰋖", "󰒓", "󰘕", "󰘖"]) {
        action.glyph = icon
        check(Math.abs(glyph.paintedCenterX - action.width / 2) < 0.01, "horizontal ink center")
        check(Math.abs(glyph.paintedCenterY - action.height / 2) < 0.01, "vertical ink center")
      }
      var proc = {pid: 12345, startTicks: 54321, name: "fixture", user: actions.currentUser, state: "S"}
      check(actions.request(proc), "request accepted")
      check(actions.pendingAction.action === "TERM", "default sends TERM only")
      proc.pid = 45678
      check(actions.pendingAction.pid === 12345, "confirmation captures immutable identity")
      actions.cancel()
      check(!actions.confirmationOpen, "cancel clears request")
      check(actions.request(proc, true), "force request accepted")
      check(actions.pendingAction.action === "KILL", "force must be explicit")
      actions.enabled = false
      check(!actions.confirmationOpen, "disabling actions clears confirmation")
      actions.confirm()
      check(!actions.running, "disabled action cannot execute")
      actions.enabled = true; actions.active = false
      check(!actions.request(proc), "closed panel cannot request termination")
      actions.active = true
      check(!actions.request({pid: 1, startTicks: 1, name: "systemd", user: "root"}), "protected process rejected")
    }
  }
}

import QtQuick
import qs.Commons
import qs.Ui

// Native button states, with the painted glyph centered on both axes.
// Unlike bar text, standalone square actions do not need a shared baseline.
Button {
  id: root
  property string glyph: ""
  property string helpText: ""
  property Item tooltipBounds: null
  property bool hoveredNow: false
  implicitWidth: Style.space(28)
  implicitHeight: Style.space(28)
  focusable: true
  bordered: true
  onHovered: function(value) { hoveredNow = value }

  TextMetrics {
    id: glyphMetrics
    font.family: root.fontFamily
    font.pixelSize: Math.max(1, Math.round(Style.font.icon))
    text: root.glyph
  }

  Text {
    id: glyphText
    objectName: "centeredGlyph"
    readonly property rect ink: glyphMetrics.tightBoundingRect
    readonly property real paintedCenterX: x + ink.x + ink.width / 2
    readonly property real paintedCenterY: y + baselineOffset + ink.y + ink.height / 2
    x: (root.width - ink.width) / 2 - ink.x
    y: (root.height - ink.height) / 2 - baselineOffset - ink.y
    textFormat: Text.PlainText
    text: root.glyph
    font: glyphMetrics.font
    color: root.foreground
    renderType: Text.NativeRendering
  }

  BoundedToolTip {
    boundsItem: root.tooltipBounds
    visible: root.hoveredNow && root.helpText !== ""
    text: root.helpText
    fontFamily: root.fontFamily
  }
}

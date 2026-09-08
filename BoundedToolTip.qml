import QtQuick
import qs.Commons
import qs.Ui

PanelToolTip {
  id: root
  property Item boundsItem: null
  readonly property point origin: boundsItem && parent
    ? parent.mapToItem(boundsItem, 0, 0) : Qt.point(0, 0)
  width: Math.min(implicitWidth, boundsItem ? boundsItem.width : Style.space(300))
  x: boundsItem ? Math.max(-origin.x, Math.min((parent.width - width) / 2,
    boundsItem.width - origin.x - width)) : 0
  y: boundsItem ? Math.max(-origin.y, Math.min(parent.height + Style.spacing.sm,
    boundsItem.height - origin.y - height)) : parent.height
  contentItem: Text {
    textFormat: Text.PlainText
    text: root.text
    color: root.panelForeground
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    wrapMode: Text.Wrap
    leftPadding: Style.spacing.controlPaddingX
    rightPadding: Style.spacing.controlPaddingX
    topPadding: Style.spacing.controlPaddingY
    bottomPadding: Style.spacing.controlPaddingY
  }
}

import QtQuick
import qs.components
import qs.services

MaterialIcon {
    id: root

    required property color colour

    animate: true
    text: "coffee"
    color: KeepAwake.enabled ? Colours.palette.m3primary : root.colour
    fill: KeepAwake.enabled ? 1 : 0

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: KeepAwake.toggle()
    }
}

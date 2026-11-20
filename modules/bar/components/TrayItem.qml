pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.SystemTray
import Hel.Config
import qs.components.effects
import qs.services
import qs.utils

MouseArea {
    id: root

    required property SystemTrayItem modelData

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: Math.round(Tokens.font.body.small.pointSize * 1.7)
    implicitHeight: Math.round(Tokens.font.body.small.pointSize * 1.7)

    onClicked: event => {
        if (event.button === Qt.LeftButton)
            modelData.activate();
        else
            modelData.secondaryActivate();
    }

    ColouredIcon {
        id: icon

        anchors.fill: parent
        source: Icons.getTrayIcon(root.modelData.id, root.modelData.icon)
        colour: Colours.palette.m3secondary
        layer.enabled: Config.bar.tray.recolour
    }
}

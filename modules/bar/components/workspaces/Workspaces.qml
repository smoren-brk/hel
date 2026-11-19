pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

Column {
    id: root

    required property ShellScreen screen

    spacing: Tokens.spacing.small

    Repeater {
        model: ScriptModel {
            values: NiriService.workspacesForOutput(root.screen.name).filter(ws => root.Config.bar.workspaces.showUnoccupied || ws.isActive || NiriService.windows.some(window => window.workspaceId === ws.id))
        }

        delegate: StyledRect {
            id: entry

            required property var modelData

            implicitWidth: root.Tokens.sizes.bar.innerWidth
            implicitHeight: Math.max(implicitWidth, labels.implicitHeight + root.Tokens.padding.small)
            radius: implicitWidth / 2
            color: modelData.isActive ? Colours.palette.m3primaryContainer : "transparent"

            Column {
                id: labels

                anchors.centerIn: parent
                spacing: root.Tokens.spacing.extraSmall

                StyledText {
                    anchors.horizontalCenter: labels.horizontalCenter
                    text: entry.modelData.index
                    font: root.Tokens.font.body.builders.small.scale(0.95).build()
                    color: entry.modelData.isActive ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                }

                Repeater {
                    model: root.Config.bar.workspaces.showWindows ? NiriService.windows.filter(window => window.workspaceId === entry.modelData.id).slice(0, root.Config.bar.workspaces.maxWindowIcons) : []

                    MaterialIcon {
                        required property var modelData

                        anchors.horizontalCenter: labels.horizontalCenter
                        text: Icons.getAppCategoryIcon(modelData.appId, "desktop_windows")
                        fontStyle: root.Tokens.font.icon.builders.small.scale(0.85).build()
                        color: entry.modelData.isActive ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurface
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: NiriService.activateWorkspace(entry.modelData.id)
            }
        }
    }
}

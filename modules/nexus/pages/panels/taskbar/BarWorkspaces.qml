pragma ComponentBehavior: Bound

import QtQuick.Layouts
import Hel.Config
import Hel.I18n
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Workspaces")
    isSubPage: true

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        ToggleRow {
            first: true
            text: Tr.trCtx("Show unoccupied", "bar workspaces")
            subtext: Tr.tr("Show workspaces that are inactive and empty")
            checked: Config.bar.workspaces.showUnoccupied
            onToggled: GlobalConfig.bar.workspaces.showUnoccupied = checked
        }

        ToggleRow {
            text: Tr.trCtx("Show windows", "bar workspaces")
            checked: Config.bar.workspaces.showWindows
            onToggled: GlobalConfig.bar.workspaces.showWindows = checked
        }

        StepperRow {
            last: true
            label: Tr.trCtx("Max window icons", "bar workspaces")
            value: Config.bar.workspaces.maxWindowIcons
            from: 0
            to: 20
            stepSize: 1
            onMoved: v => GlobalConfig.bar.workspaces.maxWindowIcons = v
        }
    }
}

import QtQuick
import Hel.Config
import Hel.I18n
import qs.components
import qs.services

Column {
    id: root

    spacing: Tokens.spacing.medium

    StyledText {
        text: KeepAwake.enabled
            // TRANSLATORS: %1 = a clock time, e.g. 14:30
            ? Tr.tr("Active since %1").arg(Tr.formatDateTime(new Date(KeepAwake.activeSince), Units.twelveHourClock ? "hh:mm a" : "hh:mm"))
            : Tr.tr("Not active")
        color: KeepAwake.enabled ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
        font: Tokens.font.body.medium
    }
}

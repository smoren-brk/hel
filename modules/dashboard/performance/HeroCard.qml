import QtQuick
import QtQuick.Layouts
import Hel.Config
import Hel.I18n
import qs.components
import qs.services
import qs.utils

StyledRect {
    id: root

    required property string icon
    required property string label
    required property string subLabel
    required property color accent
    required property real usage
    required property real temperature

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.extraLarge
    implicitWidth: Tokens.sizes.dashboard.perfHeroCardWidth
    implicitHeight: layout.implicitHeight + Tokens.padding.large * 2

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        spacing: Tokens.spacing.small

        RowLayout {
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: root.icon
                color: root.accent
                fontStyle: Tokens.font.icon.medium
            }

            StyledText {
                Layout.fillWidth: true
                text: root.label
                font: Tokens.font.title.medium
            }

            StyledText {
                text: isNaN(root.usage) ? "—" : Strings.percentOne(root.usage)
                color: root.accent
                font: Tokens.font.title.medium
            }
        }

        StyledText {
            Layout.fillWidth: true
            text: root.subLabel
            font: Tokens.font.body.small
            color: Colours.palette.m3onSurfaceVariant
            elide: Text.ElideRight
        }

        RowLayout {
            spacing: Tokens.spacing.extraSmall

            MaterialIcon {
                text: root.temperature > 90 ? "thermometer_alert" : "thermometer"
                color: root.temperature > 90 ? Colours.palette.m3error : root.accent
                fontStyle: Tokens.font.icon.medium
            }

            StyledText {
                text: root.temperature > 0 ? Units.formatSensorTemp(root.temperature) : "—"
                font: Tokens.font.body.medium
            }
        }
    }
}

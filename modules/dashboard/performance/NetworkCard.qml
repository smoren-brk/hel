import QtQuick
import QtQuick.Layouts
import Hel.Config
import Hel.I18n
import Hel.Services
import qs.components
import qs.services

StyledRect {
    id: root

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.extraLarge

    implicitWidth: Tokens.sizes.dashboard.perfNetworkCardWidth
    implicitHeight: layout.implicitHeight + Tokens.padding.large + Tokens.padding.medium

    ServiceRef {
        service: NetworkUsage
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Tokens.padding.large
        anchors.bottomMargin: Tokens.padding.medium
        spacing: 0

        RowLayout {
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "swap_vert"
                color: Colours.palette.m3primary
                fontStyle: Tokens.font.icon.medium
            }

            StyledText {
                text: Tr.tr("Network")
                font: Tokens.font.title.medium
            }
        }

        // Download row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "download"
                color: Colours.palette.m3tertiary
                fontStyle: Tokens.font.icon.medium
            }

            StyledText {
                text: Tr.trCtx("Download", "network throughput")
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: Units.formatBytes(NetworkUsage.downloadSpeed ?? 0, true)
                font: Tokens.font.body.builders.medium.weight(Font.Medium).build()
                color: Colours.palette.m3tertiary
            }
        }

        // Upload row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "upload"
                color: Colours.palette.m3secondary
                fontStyle: Tokens.font.icon.medium
            }

            StyledText {
                text: Tr.trCtx("Upload", "network throughput")
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: Units.formatBytes(NetworkUsage.uploadSpeed ?? 0, true)
                font: Tokens.font.body.builders.medium.weight(Font.Medium).build()
                color: Colours.palette.m3secondary
            }
        }

        // Session totals
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            MaterialIcon {
                text: "history"
                color: Colours.palette.m3onSurfaceVariant
                fontStyle: Tokens.font.icon.medium
            }

            StyledText {
                text: Tr.trCtx("Total", "total network data transferred")
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    const downText = Units.formatBytes(NetworkUsage.downloadTotal ?? 0);
                    const upText = Units.formatBytes(NetworkUsage.uploadTotal ?? 0);
                    // TRANSLATORS: %1 = downloaded total, %2 = uploaded total
                    return Tr.tr("↓%1 ↑%2").arg(downText).arg(upText);
                }
                font: Tokens.font.body.small
                color: Colours.palette.m3onSurfaceVariant
            }
        }
    }
}

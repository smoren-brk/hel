import QtQuick.Layouts
import Hel.Config
import qs.components
import qs.components.filedialog
import qs.services
import qs.modules.dashboard.dash

GridLayout {
    id: root

    required property ScreenState screenState
    required property FileDialog facePicker

    rowSpacing: Tokens.spacing.medium
    columnSpacing: Tokens.spacing.medium

    Rect {
        Layout.row: 0
        Layout.column: 1
        Layout.preferredWidth: Tokens.sizes.dashboard.userWidth
        Layout.fillHeight: true

        radius: Tokens.rounding.large

        User {
            id: user

            screenState: root.screenState
            facePicker: root.facePicker
        }
    }

    Rect {
        Layout.row: 0
        Layout.column: 0
        Layout.preferredWidth: Tokens.sizes.dashboard.weatherWidth
        Layout.preferredHeight: weather.implicitHeight

        radius: Tokens.rounding.large

        SmallWeather {
            id: weather
        }
    }

    Rect {
        Layout.row: 1
        Layout.column: 0
        Layout.columnSpan: 2
        Layout.fillWidth: true
        Layout.preferredHeight: calendar.implicitHeight

        radius: Tokens.rounding.large

        Calendar {
            id: calendar

            anchors.fill: parent

            screenState: root.screenState
        }
    }

    Rect {
        Layout.row: 0
        Layout.column: 2
        Layout.rowSpan: 2
        Layout.preferredWidth: media.implicitWidth
        Layout.fillHeight: true

        radius: Tokens.rounding.large

        Media {
            id: media
        }
    }

    component Rect: StyledRect {
        color: Colours.palette.m3surfaceContainer
    }
}

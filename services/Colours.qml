pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
    id: root

    property string scheme: "Carbonfox"
    property string flavour
    readonly property bool light: currentLight
    property bool currentLight
    readonly property M3Palette palette: current
    readonly property M3Palette current: M3Palette {}

    function load(data: string): void {
        const scheme = JSON.parse(data);
        root.scheme = scheme.name;
        flavour = scheme.flavour;
        currentLight = scheme.mode === "light";

        for (const [name, colour] of Object.entries(scheme.colours)) {
            const propName = name.startsWith("term") ? name : `m3${name}`;
            if (current.hasOwnProperty(propName))
                current[propName] = Qt.alpha(`#${colour}`, 1);
        }
    }

    FileView {
        path: `${Paths.state}/scheme.json`
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.load(text())
    }

    component M3Palette: QtObject {
        property color m3primary_paletteKeyColor: "#78a9ff"
        property color m3secondary_paletteKeyColor: "#78a9ff"
        property color m3tertiary_paletteKeyColor: "#78a9ff"
        property color m3neutral_paletteKeyColor: "#7b7c7e"
        property color m3neutral_variant_paletteKeyColor: "#b6b8bb"
        property color m3background: "#161616"
        property color m3onBackground: "#f2f4f8"
        property color m3surface: "#161616"
        property color m3surfaceDim: "#161616"
        property color m3surfaceBright: "#353535"
        property color m3surfaceContainerLowest: "#0c0c0c"
        property color m3surfaceContainerLow: "#252525"
        property color m3surfaceContainer: "#252525"
        property color m3surfaceContainerHigh: "#353535"
        property color m3surfaceContainerHighest: "#525253"
        property color m3onSurface: "#f2f4f8"
        property color m3surfaceVariant: "#353535"
        property color m3onSurfaceVariant: "#b6b8bb"
        property color m3inverseSurface: "#f2f4f8"
        property color m3inverseOnSurface: "#161616"
        property color m3outline: "#7b7c7e"
        property color m3outlineVariant: "#525253"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: "#78a9ff"
        property color m3primary: "#78a9ff"
        property color m3onPrimary: "#161616"
        property color m3primaryContainer: "#353535"
        property color m3onPrimaryContainer: "#8cb6ff"
        property color m3inversePrimary: "#353535"
        property color m3secondary: "#78a9ff"
        property color m3onSecondary: "#161616"
        property color m3secondaryContainer: "#353535"
        property color m3onSecondaryContainer: "#8cb6ff"
        property color m3tertiary: "#78a9ff"
        property color m3onTertiary: "#161616"
        property color m3tertiaryContainer: "#353535"
        property color m3onTertiaryContainer: "#8cb6ff"
        property color m3error: "#ee5396"
        property color m3onError: "#161616"
        property color m3errorContainer: "#36212a"
        property color m3onErrorContainer: "#ee5396"
        property color m3success: "#25be6a"
        property color m3onSuccess: "#161616"
        property color m3successContainer: "#182f23"
        property color m3onSuccessContainer: "#25be6a"
        property color m3primaryFixed: "#8cb6ff"
        property color m3primaryFixedDim: "#78a9ff"
        property color m3onPrimaryFixed: "#161616"
        property color m3onPrimaryFixedVariant: "#353535"
        property color m3secondaryFixed: "#8cb6ff"
        property color m3secondaryFixedDim: "#78a9ff"
        property color m3onSecondaryFixed: "#161616"
        property color m3onSecondaryFixedVariant: "#353535"
        property color m3tertiaryFixed: "#8cb6ff"
        property color m3tertiaryFixedDim: "#78a9ff"
        property color m3onTertiaryFixed: "#161616"
        property color m3onTertiaryFixedVariant: "#353535"
        property color term0: "#282828"
        property color term1: "#ee5396"
        property color term2: "#25be6a"
        property color term3: "#08bdba"
        property color term4: "#78a9ff"
        property color term5: "#be95ff"
        property color term6: "#33b1ff"
        property color term7: "#dfdfe0"
        property color term8: "#484848"
        property color term9: "#f16da6"
        property color term10: "#46c880"
        property color term11: "#2dc7c4"
        property color term12: "#8cb6ff"
        property color term13: "#c8a5ff"
        property color term14: "#52bdff"
        property color term15: "#e4e4e5"
    }
}

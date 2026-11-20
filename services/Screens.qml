pragma Singleton

import Quickshell
import Hel.Config

Singleton {
    id: root

    readonly property list<ShellScreen> screens: Quickshell.screens.filter(s => GlobalConfig.forScreen(s.name).enabled)
    // The output placed at the compositor origin is treated as the main display
    readonly property ShellScreen main: screens.find(s => s.x === 0 && s.y === 0) ?? screens[0]

    function isMain(screen: ShellScreen): bool {
        return screen === main;
    }

    function isExcluded(screen: ShellScreen): bool {
        return !GlobalConfig.forScreen(screen.name).enabled;
    }
}

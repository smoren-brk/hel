pragma Singleton

import QtQuick
import Quickshell
import Hel.State

Singleton {
    readonly property bool enabled: PersistentState.inhibitIdle
    readonly property real activeSince: PersistentState.inhibitingIdleSince

    function setEnabled(value: bool): void {
        if (value === enabled)
            return;

        if (value)
            PersistentState.inhibitingIdleSince = Date.now();
        PersistentState.inhibitIdle = value;
    }

    function toggle(): void {
        setEnabled(!enabled);
    }
}

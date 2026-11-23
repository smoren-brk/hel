import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services

Scope {
    IdleInhibitor {
        enabled: KeepAwake.enabled

        window: PanelWindow {
            implicitWidth: 0
            implicitHeight: 0
            color: "transparent"
            mask: Region {}
        }
    }

    IpcHandler {
        function isEnabled(): bool {
            return KeepAwake.enabled;
        }

        function toggle(): void {
            KeepAwake.toggle();
        }

        function enable(): void {
            KeepAwake.setEnabled(true);
        }

        function disable(): void {
            KeepAwake.setEnabled(false);
        }

        target: "idleInhibitor"
    }
}

import QtQuick
import Quickshell
import Quickshell.Io
import Hel
import Hel.Config
import Hel.I18n
import qs.services
import qs.modules.nexus

Scope {
    id: root

    readonly property bool hasFullscreen: NiriService.hasFullscreen(NiriService.focusedOutput)

    function barMode(): string {
        if (GlobalConfig.bar.persistent)
            return "always";
        return GlobalConfig.bar.showOnHover ? "hover" : "hidden";
    }

    function setBarMode(mode: string): void {
        GlobalConfig.bar.persistent = mode === "always";
        GlobalConfig.bar.showOnHover = mode !== "hidden";
        for (let i = 0; i < Screens.screens.length; i++)
            ShellState.forScreen(Screens.screens[i]).bar = false;
    }

    IpcHandler {
        function toggle(drawer: string): void {
            if (list().split("\n").includes(drawer)) {
                if (root.hasFullscreen && ["launcher", "session", "dashboard"].includes(drawer))
                    return;
                const screenState = ShellState.forActive();
                screenState[drawer] = !screenState[drawer];
            } else {
                console.warn(lc, `Drawer "${drawer}" does not exist`);
            }
        }

        function list(): string {
            const screenState = ShellState.forActive();
            return Object.keys(screenState ?? {}).filter(k => typeof screenState[k] === "boolean").join("\n");
        }

        function isOpen(drawer: string): string {
            const screenState = ShellState.forActive();
            if (typeof screenState?.[drawer] !== "boolean")
                return "unknown";
            return screenState[drawer] ? "1" : "0";
        }

        target: "drawers"
    }

    IpcHandler {
        function mode(): string {
            return root.barMode();
        }

        function cycle(): void {
            const current = root.barMode();
            const next = current === "always" ? "hover" : current === "hover" ? "hidden" : "always";
            const labels = {
                always: Tr.tr("Always shown"),
                hover: Tr.tr("Show on hover"),
                hidden: Tr.tr("Always hidden")
            };
            root.setBarMode(next);
            Toaster.toast(Tr.tr("Status bar"), labels[next], "dock");
        }

        target: "bar"
    }

    IpcHandler {
        function open(): void {
            WindowFactory.create();
        }

        target: "nexus"
    }

    IpcHandler {
        function info(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.Info);
        }

        function success(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.Success);
        }

        function warn(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.Warning);
        }

        function error(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.Error);
        }

        target: "toaster"
    }

    LoggingCategory {
        id: lc

        name: "hel.qml.shortcuts"
        defaultLogLevel: LoggingCategory.Info
    }
}

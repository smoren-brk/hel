pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Niri

Singleton {
    id: root

    property var workspaces: []
    property var windows: []
    property bool connected: false
    readonly property string focusedOutput: workspaces.find(workspace => workspace.isFocused)?.output || ""

    readonly property var focusedWindow: connected ? niri.focusedWindow : null
    readonly property var layouts: niri.keyboardLayouts

    function visibleWindows(output: string): var {
        const workspace = workspaces.find(ws => ws.output === output && ws.isActive);
        return workspace ? windows.filter(window => window.workspaceId === workspace.id) : [];
    }

    function hasFullscreen(output: string): bool {
        return ToplevelManager.toplevels.values.some(window => window.fullscreen && window.screens.some(screen => screen.name === output));
    }

    function workspacesForOutput(name: string): var {
        return workspaces.filter(workspace => workspace.output === name).sort((left, right) => left.index - right.index);
    }

    // Model.get() returns snapshots; refresh on role changes as well as row changes.
    function refreshWorkspaces(): void {
        const result = [];
        if (connected) {
            for (let row = 0; row < niri.workspaces.count; row++)
                result.push(niri.workspaces.get(row));
        }
        workspaces = result;
    }

    function switchLayout(index: int): void {
        const result = niri.switchKeyboardLayoutByIndex(index);
        if (!result.ok)
            console.warn("Could not switch keyboard layout:", result.error);
    }

    function activateWorkspace(id: real): void {
        const result = niri.focusWorkspaceById(id);
        if (!result.ok)
            console.warn("Could not activate Niri workspace:", result.error);
    }

    function refreshWindows(): void {
        const result = [];
        if (connected) {
            for (let row = 0; row < windowObjects.count; row++) {
                const object = windowObjects.objectAt(row);
                if (object)
                    result.push(object.snapshot);
            }
        }
        windows = result;
    }

    Instantiator {
        id: windowObjects

        model: niri.windows
        delegate: QtObject {
            required property var model
            readonly property var snapshot: ({
                    id: model.id,
                    appId: model.appId,
                    workspaceId: model.workspaceId,
                    isFloating: model.isFloating
                })

            onSnapshotChanged: Qt.callLater(root.refreshWindows)
        }
        onObjectAdded: Qt.callLater(root.refreshWindows)
        onObjectRemoved: Qt.callLater(root.refreshWindows)
    }

    // Shared connection, following imiric/quickshell-niri's service pattern.
    Niri {
        id: niri

        Component.onCompleted: {
            if (Quickshell.env("NIRI_SOCKET"))
                connect();
        }
        onConnected: {
            root.connected = true;
            root.refreshWorkspaces();
            root.refreshWindows();
        }
        onDisconnected: {
            root.connected = false;
            root.workspaces = [];
            root.windows = [];
        }
        onErrorOccurred: error => console.warn("Niri connection error:", error)
    }

    Connections {
        function onDataChanged() {
            root.refreshWorkspaces();
        }
        function onModelReset() {
            root.refreshWorkspaces();
        }
        function onRowsInserted() {
            root.refreshWorkspaces();
        }
        function onRowsRemoved() {
            root.refreshWorkspaces();
        }
        function onRowsMoved() {
            root.refreshWorkspaces();
        }
        function onLayoutChanged() {
            root.refreshWorkspaces();
        }

        target: niri.workspaces
    }

    Timer {
        interval: 1000
        repeat: true
        running: !!Quickshell.env("NIRI_SOCKET") && !root.connected
        onTriggered: niri.connect()
    }
}

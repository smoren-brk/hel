pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Hel.Config
import Hel.State
import Hel.Models
import qs.utils

Searcher {
    id: root

    readonly property string fallback: Quickshell.env("HEL_WALLPAPER") || Quickshell.shellPath("assets/wallpaper.webp")

    property bool showPreview: false
    readonly property string current: showPreview ? previewPath : actualCurrent
    property string previewPath
    readonly property string actualCurrent: PersistentState.wallpaperPath || fallback

    function setRandom(): void {
        if (list.length)
            setWallpaper(list[Math.floor(Math.random() * list.length)].path);
    }

    function setWallpaper(path: string): void {
        PersistentState.wallpaperPath = path;
    }

    function preview(path: string): void {
        previewPath = path;
        showPreview = true;
    }

    function stopPreview(): void {
        showPreview = false;
    }

    list: wallpapers.entries
    key: "relativePath"
    useFuzzy: GlobalConfig.launcher.useFuzzy.wallpapers
    extraOpts: useFuzzy ? ({}) : ({
            forward: false
        })

    IpcHandler {
        function get(): string {
            return root.actualCurrent;
        }

        function set(path: string): void {
            root.setWallpaper(path);
        }

        function list(): string {
            return root.list.map(w => w.path).join("\n");
        }

        target: "wallpaper"
    }

    FileSystemModel {
        id: wallpapers

        recursive: true
        path: Paths.wallsdir
        filter: FileSystemModel.Images | FileSystemModel.Videos
    }
}

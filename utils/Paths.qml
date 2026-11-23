pragma Singleton

import QtQuick
import Quickshell
import Hel
import Hel.Config

Singleton {
    id: root

    readonly property string home: Quickshell.env("HOME")

    readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`}/hel`
    readonly property string cache: `${Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`}/hel`

    readonly property string imagecache: `${cache}/imagecache`
    readonly property string notifimagecache: `${imagecache}/notifs`
    readonly property string wallsdir: Quickshell.env("HEL_WALLPAPERS_DIR") || absolutePath(GlobalConfig.paths.wallpaperDir)

    function toLocalFile(path: url): string {
        path = Qt.resolvedUrl(path);
        return path.toString() ? CUtils.toLocalFile(path) : "";
    }

    function absolutePath(path: string): string {
        return toLocalFile(path.replace(/~|(\$({?)HOME(}?))+/, home));
    }

    function shortenHome(path: string): string {
        return path.replace(home, "~");
    }
}

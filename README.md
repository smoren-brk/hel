# Hel

Hel is a QuickShell desktop shell for Niri on NixOS. Each display gets a bar with its own workspaces. Click a workspace number or scroll over the numbers to switch. The active window title and keyboard-triggered drawers follow focus through qml-niri. The OSD provides speaker and microphone controls.

## Run on NixOS

From a running Niri session, try the shell with flakes enabled.

```sh
nix run github:smoren-brk/hel
```

To build and run a checkout, use `nix build` and `./result/bin/hel`. The package includes QuickShell, qml-niri, and Hel’s QML plugins.

## Home Manager

Add Hel to your configuration flake.

```nix
inputs.hel.url = "github:smoren-brk/hel";
```

In your Home Manager configuration, import the module and enable the service.

```nix
{ inputs, ... }: {
  imports = [ inputs.hel.homeManagerModules.default ];
  programs.hel = {
    enable = true;
    settings.bar.workspaces.showUnoccupied = true;
  };
}
```

The module installs `hel` and starts it with the graphical session. Use `journalctl --user -u hel -b` for logs. Update the pinned shell with `nix flake update hel` in your configuration flake and apply your configuration.

## Niri key bindings

Add bindings to your Niri configuration after installing the package. Each command talks to the running shell.

```kdl
binds {
    Mod+Space { spawn "hel" "ipc" "call" "drawers" "toggle" "launcher"; }
    Mod+Shift+Space { spawn "hel" "ipc" "call" "nexus" "open"; }
    Mod+Shift+S { spawn "hel" "ipc" "call" "picker" "openFreezeClip"; }
}
```

Run `hel ipc show` to list IPC targets and methods. The picker captures a dragged rectangle. Workspace buttons switch immediately on click and show the active workspace on each output.

The bar mode is cycled with `hel ipc call bar cycle` through always shown, reveal on hover, and always hidden. `hel ipc call bar mode` reports the current mode. By default the bar is only drawn on the main output (the screen at the compositor origin); disable `bar.onlyOnMainScreen` to show it on every display.

## Configuration

Open settings with `hel ipc call nexus open`. Existing shell settings use `~/.config/caelestia/shell.json`. An output-specific override goes in `~/.config/caelestia/monitors/DP-1/shell.json`, replacing `DP-1` with an output name from `niri msg outputs`. For example, this hides the bar until it is needed on that display.

```json
{
  "bar": { "persistent": false }
}
```

Hel uses opaque Carbonfox panels. Hover over the bar clock to open the calendar. The dashboard shows Novi Sad weather in Celsius by default. Its Performance tab shows CPU and supported GPU usage histories, current percentages, and available sensor temperatures. Disk usage appears on the Performance tab.

The launcher reads wallpapers from `~/Pictures/Wallpapers` by default. Set `paths.wallpaperDir` to change the directory. Set `CAELESTIA_WALLPAPER` to a file path to override the fallback wallpaper. Type `>wallpaper` in the launcher or run `hel ipc call wallpaper set /absolute/path/to/image`. Hel saves the selection between sessions. The dashboard reads the profile picture from `~/.face`.

The [configuration definitions](plugin/src/Caelestia/Config) list the available settings and defaults. Visual tokens can be overridden in `shell-tokens.json` alongside the main settings file.

## Development

Run `nix develop` for the build tools and `nix build` to check the complete package. Run `python3 scripts/qml-lint-conventions.py` to check QML conventions. The shell is distributed under the [GPL](LICENSE). The snowflake artwork comes from [NixOS artwork](https://github.com/NixOS/nixos-artwork).

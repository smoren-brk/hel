# Hel

Hel is a QuickShell desktop shell for Niri on NixOS. Each display gets a bar with its own workspaces. Click a workspace number or scroll over the numbers to switch. The active window title and keyboard-triggered drawers follow focus through qml-niri. The OSD provides speaker and microphone controls.

## Run on NixOS

From a running Niri session, try the shell with flakes enabled.

```sh
nix run github:smoren-brk/hel
```

To build and run a checkout, use `nix build` and `./result/bin/hel`. The package includes QuickShell, qml-niri, and Hel’s QML plugins.

## Niri key bindings

Add bindings to your Niri configuration after installing the package. Each command talks to the running shell.

```kdl
binds {
    Mod+Space { spawn "hel" "ipc" "call" "drawers" "toggle" "launcher"; }
    Mod+Shift+D { spawn "hel" "ipc" "call" "drawers" "toggle" "dashboard"; }
    Mod+Shift+S { spawn "hel" "ipc" "call" "picker" "openFreezeClip"; }
}
```

Run `hel ipc show` to list IPC targets and methods. The picker captures a dragged rectangle. Workspace buttons switch immediately on click and show the active workspace on each output.

The bar mode is cycled with `hel ipc call bar cycle` through always shown, reveal on hover, and always hidden. `hel ipc call bar reset` returns to the configured mode, and `hel ipc call bar mode` reports the current mode. By default the bar is only drawn on the main output (the screen at the compositor origin); disable `bar.onlyOnMainScreen` to show it on every display.

## Configuration

Shell settings use `~/.config/hel/shell.json`, which the shell watches for changes. An output-specific override goes in `~/.config/hel/monitors/DP-1/shell.json`, replacing `DP-1` with an output name from `niri msg outputs`. For example, this makes the bar reveal on hover on that display.

```json
{
  "bar": { "persistent": false }
}
```

The bar is always visible by default, and the dashboard opens from its key binding rather than on hover.

Hel uses opaque Carbonfox panels. Hover over the bar clock to open the calendar. The dashboard shows Novi Sad weather in Celsius by default.

The launcher reads wallpapers from `~/Pictures/Wallpapers` by default. Set `paths.wallpaperDir` to change the directory. Set `HEL_WALLPAPER` to a file path to override the fallback wallpaper. Type `>wallpaper` in the launcher or run `hel ipc call wallpaper set /absolute/path/to/image`. Hel saves the selection between sessions. The dashboard reads the profile picture from `~/.face`.

The [configuration definitions](plugin/src/Hel/Config) list the available settings and defaults. Visual tokens can be overridden in `shell-tokens.json` alongside the main settings file.

## NixOS module

The flake exports `nixosModules.default`, which installs the shell and writes the JSON config for the listed users. Add the flake input and import the module:

```nix
{
  inputs.hel.url = "github:smoren-brk/hel";

  # In a NixOS configuration:
  imports = [ inputs.hel.nixosModules.default ];

  programs.hel = {
    enable = true;
    users = [ "alice" ];

    settings = {
      bar = {
        persistent = false;
        showOnHover = true;
      };
      services.weatherLocation = "Novi Sad";
    };

    tokens = {
      sizes.bar.innerWidth = 40;
    };

    monitors."DP-1".settings = {
      bar.persistent = true;
    };
  };
}
```

`settings` and `tokens` are written to `~/.config/hel/shell.json` and `~/.config/hel/shell-tokens.json`, and `monitors.<output>` writes the per-output overrides under `~/.config/hel/monitors`. The files are symlinked from the Nix store for each user in `programs.hel.users`; the package is installed for every user regardless. Enabling the module replaces any existing files at those paths, so move manual settings into `programs.hel.settings` first.

Because the config belongs to Nix, edit it through the module rather than the symlinked files. Runtime changes such as `hel ipc call bar cycle` are kept in the shell's state directory instead of rewriting the config. Run `hel ipc call bar reset` to return to the configured bar mode.

## Development

Run `nix develop` for the build tools and `nix build` to check the complete package. Run `python3 scripts/qml-lint-conventions.py` to check QML conventions. The shell is distributed under the [GPL](LICENSE). The snowflake artwork comes from [NixOS artwork](https://github.com/NixOS/nixos-artwork).

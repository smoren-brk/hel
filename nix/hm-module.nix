self: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;

  shell-default = self.packages.${system}.hel;

  cfg = config.programs.hel;
in {
  options = with lib; {
    programs.hel = {
      enable = mkEnableOption "Enable Hel shell";
      package = mkOption {
        type = types.package;
        default = shell-default;
        description = "The package of Hel shell";
      };
      systemd = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable the systemd service for Hel shell";
        };
        target = mkOption {
          type = types.str;
          description = ''
            The systemd target that will automatically start the Hel shell.
          '';
          default = config.wayland.systemd.target;
        };
        environment = mkOption {
          type = types.listOf types.str;
          description = "Extra Environment variables to pass to the Hel shell systemd service.";
          default = [];
          example = [
            "QT_QPA_PLATFORMTHEME=gtk3"
          ];
        };
      };
      settings = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        description = "Hel shell settings";
      };
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Hel shell extra configs written to shell.json";
      };
    };
  };

  config = let
    shell = cfg.package;
  in
    lib.mkIf cfg.enable {
      home.packages = [shell];
      systemd.user.services.hel = lib.mkIf cfg.systemd.enable {
        Unit = {
          Description = "Hel Shell Service";
          After = [cfg.systemd.target];
          PartOf = [cfg.systemd.target];
          X-Restart-Triggers = lib.mkIf (cfg.settings != {}) [
            "${config.xdg.configFile."caelestia/shell.json".source}"
          ];
        };

        Service = {
          Type = "exec";
          ExecStart = "${shell}/bin/hel";
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStopSec = "5s";
          Environment =
            [
              "QT_QPA_PLATFORM=wayland"
            ]
            ++ cfg.systemd.environment;

          Slice = "session.slice";
        };

        Install = {
          WantedBy = [cfg.systemd.target];
        };
      };

      xdg.configFile = let
        mkConfig = c:
          lib.pipe (
            if c.extraConfig != ""
            then c.extraConfig
            else "{}"
          ) [
            builtins.fromJSON
            (lib.recursiveUpdate c.settings)
            builtins.toJSON
          ];
        shouldGenerate = c: c.extraConfig != "" || c.settings != {};
      in {
        "caelestia/shell.json" = lib.mkIf (shouldGenerate cfg) {
          text = mkConfig cfg;
        };
      };

    };
}

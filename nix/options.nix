{self}: {
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.programs.hel = {
    enable = mkEnableOption "Hel desktop shell";

    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultText = lib.literalExpression "inputs.hel.packages.\${pkgs.stdenv.hostPlatform.system}.default";
      description = "The Hel package to install.";
    };

    settings = mkOption {
      type = types.attrsOf types.json;
      default = {};
      description = ''
        Shell configuration, written to `shell.json`. See the
        [configuration definitions](https://github.com/smoren-brk/hel/tree/main/plugin/src/Hel/Config)
        for the available keys.
      '';
    };

    tokens = mkOption {
      type = types.attrsOf types.json;
      default = {};
      description = ''
        Visual token overrides, written to `shell-tokens.json`. See
        `plugin/src/Hel/Config/tokens.hpp` for the available tokens.
      '';
    };

    monitors = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            settings = mkOption {
              type = types.attrsOf types.json;
              default = {};
              description = "Per-output shell configuration.";
            };

            tokens = mkOption {
              type = types.attrsOf types.json;
              default = {};
              description = "Per-output token overrides.";
            };
          };
        }
      );
      default = {};
      example = lib.literalExpression ''
        {
          "DP-1".settings.bar.persistent = false;
        }
      '';
      description = ''
        Per-output configuration, keyed by an output name from `niri msg outputs`.
      '';
    };
  };
}

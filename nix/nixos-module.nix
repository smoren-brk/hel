{self}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hel;
  inherit (lib) concatLists genAttrs mapAttrsToList mkIf mkOption types;

  json = pkgs.formats.json {};
  configFile = json.generate "hel-shell.json" cfg.settings;
  tokensFile = json.generate "hel-shell-tokens.json" cfg.tokens;

  monitorRules = concatLists (
    mapAttrsToList (
      name: monitor: let
        dir = "${cfg.configDir}/monitors/${name}";
        safeName = lib.replaceStrings ["/" " "] ["-" "-"] name;
      in [
        "d ${dir} 0755 - - -"
        "L+ ${dir}/shell.json - - - - ${
          json.generate "hel-monitor-${safeName}-shell.json" monitor.settings
        }"
        "L+ ${dir}/shell-tokens.json - - - - ${
          json.generate "hel-monitor-${safeName}-shell-tokens.json" monitor.tokens
        }"
      ]
    )
    cfg.monitors
  );

  rules =
    [
      "d ${cfg.configDir} 0755 - - -"
      "d ${cfg.configDir}/monitors 0755 - - -"
      "L+ ${cfg.configDir}/shell.json - - - - ${configFile}"
      "L+ ${cfg.configDir}/shell-tokens.json - - - - ${tokensFile}"
    ]
    ++ monitorRules;
in {
  imports = [(import ./options.nix {inherit self;})];

  options.programs.hel.users = mkOption {
    type = types.listOf types.str;
    default = [];
    example = ["alice"];
    description = ''
      Users whose configuration is managed by this module.
      The package is installed for every user regardless of this list.
    '';
  };

  options.programs.hel.configDir = mkOption {
    type = types.str;
    default = "%h/.config/hel";
    example = "%h/.config/hel";
    description = ''
      Directory the configuration is written to. `%h` expands to the user's
      home directory; change this if `XDG_CONFIG_HOME` points elsewhere.
    '';
  };

  config = mkIf cfg.enable {
    assertions =
      lib.mapAttrsToList (name: _: {
        assertion = builtins.match "[A-Za-z0-9._-]+" name != null;
        message = "programs.hel.monitors: '${name}' is not a valid output name.";
      })
      cfg.monitors
      ++ map (user: {
        assertion = builtins.hasAttr user config.users.users;
        message = "programs.hel.users: '${user}' is not a configured user.";
      })
      cfg.users;

    warnings = lib.optional (cfg.users == []) ''
      programs.hel: no users are configured, so no shell config will be installed.
      Set programs.hel.users to the users whose configuration should be managed.
    '';

    environment.systemPackages = [cfg.package];

    systemd.user.tmpfiles.users = genAttrs cfg.users (_: {
      inherit rules;
    });
  };
}

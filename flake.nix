{
  description = "Hel desktop shell for Niri on NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qml-niri = {
      url = "github:imiric/qml-niri/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    m3shapes = {
      url = "github:soramanew/m3shapes/32ad9ce328bb77ed349b40a3be10ee9ea610b8ab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs platforms lists systems;

    pkgsOf = nixpkgs.legacyPackages;
    systems' = lists.intersectLists platforms.linux systems.flakeExposed;
    eachSystem = genAttrs systems';
  in {
    formatter = eachSystem (system: pkgsOf.${system}.alejandra);

    packages = eachSystem (system: let
      pkgs = pkgsOf.${system};
    in rec {
      hel = pkgs.callPackage ./nix {
        rev = self.rev or self.dirtyRev or "local";
        stdenv = pkgs.clangStdenv;
        quickshell = inputs.quickshell.packages.${system}.default.override {
          withX11 = false;
          withI3 = false;
          withHyprland = false;
        };
        qml-niri = inputs.qml-niri.packages.${system}.default;
        m3shapes = inputs.m3shapes.packages.${system}.default;
      };
      debug = hel.override {debug = true;};
      default = hel;
    });

    devShells = eachSystem (system: {
      default = let
        pkgs = pkgsOf.${system};
        shell = self.packages.${system}.hel;
        mkShell = pkgs.mkShell.override {stdenv = shell.stdenv;};
      in
        mkShell {
          inputsFrom = [shell shell.plugin shell.extras];
          packages = with pkgs; [clazy clang-tools python3 qt6.qtdeclarative material-symbols rubik nerd-fonts.caskaydia-cove];
        };
    });
  };
}

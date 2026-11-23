{
  rev,
  lib,
  stdenv,
  makeWrapper,
  makeFontsConf,
  fish,
  niri,
  libnotify,
  networkmanager,
  lm_sensors,
  swappy,
  wl-clipboard,
  libqalculate,
  bash,
  material-symbols,
  rubik,
  nerd-fonts,
  qt6,
  quickshell,
  aubio,
  libcava,
  fftw,
  pipewire,
  cmake,
  ninja,
  pkg-config,
  qml-niri,
  m3shapes,
  debug ? false,
  extraRuntimeDeps ? [],
}: let
  version = "1.0.0";

  qs = quickshell.withModules [qt6.qtimageformats qt6.qtmultimedia qml-niri m3shapes];

  runtimeDeps =
    [
      fish
      niri
      libnotify
      networkmanager
      lm_sensors
      swappy
      wl-clipboard
      libqalculate
      bash
    ]
    ++ extraRuntimeDeps;

  fontconfig = makeFontsConf {
    fontDirectories = [material-symbols rubik nerd-fonts.caskaydia-cove];
  };

  cmakeBuildType =
    if debug
    then "Debug"
    else "RelWithDebInfo";

  cmakeVersionFlags = [
    (lib.cmakeFeature "VERSION" version)
    (lib.cmakeFeature "GIT_REVISION" rev)
    (lib.cmakeFeature "DISTRIBUTOR" "nix-flake")
  ];

  extras = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "hel-extras${lib.optionalString debug "-debug"}";
    src = lib.fileset.toSource {
      root = ./..;
      fileset = lib.fileset.union ./../CMakeLists.txt ./../extras;
    };

    nativeBuildInputs = [cmake ninja];

    cmakeFlags =
      [
        (lib.cmakeFeature "ENABLE_MODULES" "extras")
        (lib.cmakeFeature "INSTALL_LIBDIR" "${placeholder "out"}/lib")
      ]
      ++ cmakeVersionFlags;
  };

  plugin = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "hel-qml-plugin${lib.optionalString debug "-debug"}";
    src = lib.fileset.toSource {
      root = ./..;
      fileset = lib.fileset.union ./../CMakeLists.txt ./../plugin;
    };

    nativeBuildInputs = [cmake ninja pkg-config];
    buildInputs = [qt6.qtbase qt6.qtdeclarative qt6.qtmultimedia qt6.qtshadertools libqalculate pipewire aubio libcava fftw lm_sensors];

    dontWrapQtApps = true;
    cmakeFlags =
      [
        (lib.cmakeFeature "ENABLE_MODULES" "plugin")
        (lib.cmakeFeature "INSTALL_QMLDIR" qt6.qtbase.qtQmlPrefix)
      ]
      ++ cmakeVersionFlags;
  };
in
  stdenv.mkDerivation {
    inherit version cmakeBuildType;
    pname = "hel${lib.optionalString debug "-debug"}";
    src = ./..;

    nativeBuildInputs = [cmake ninja makeWrapper qt6.wrapQtAppsHook];
    buildInputs = [qs extras plugin qt6.qtbase];
    propagatedBuildInputs = runtimeDeps;

    cmakeFlags =
      [
        (lib.cmakeFeature "ENABLE_MODULES" "shell")
        (lib.cmakeFeature "INSTALL_QSCONFDIR" "${placeholder "out"}/share/hel")
      ]
      ++ cmakeVersionFlags;

    dontStrip = debug;

    prePatch = ''
      substituteInPlace assets/pam.d/fprint \
        --replace-fail pam_fprintd.so /run/current-system/sw/lib/security/pam_fprintd.so
      substituteInPlace assets/pam.d/howdy \
        --replace-fail pam_howdy.so /run/current-system/sw/lib/security/pam_howdy.so
    '';

    postInstall = ''
      makeWrapper ${qs}/bin/qs $out/bin/hel \
        --prefix PATH : "${lib.makeBinPath runtimeDeps}" \
        --set FONTCONFIG_FILE "${fontconfig}" \
        --add-flags "-p $out/share/hel"

      mkdir -p $out/lib
      ln -s ${extras}/lib/* $out/lib/
    '';

    passthru = {
      inherit plugin extras;
    };

    meta = {
      description = "A fluid, morphing shell for your Linux desktop";
      homepage = "https://github.com/smoren-brk/hel";
      license = lib.licenses.gpl3Only;
      mainProgram = "hel";
    };
  }

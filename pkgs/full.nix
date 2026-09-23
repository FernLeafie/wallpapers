{
  lib,
  stdenvNoCC,
  version,
  pkgs,
  inputs,
  ...
}: let
  pname = "wallpapers";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = builtins.path {
      path = ../wallpapers;
      name = "${pname}-${version}";
    };

    strictDeps = true;

    preInstall = ''
      mkdir -p $out
    '';

    installPhase = ''
      runHook preInstall
      cp -r $src/* $out
      runHook postInstall
    '';

    meta = {
      description = "ferns-personal-wallpaper-collection";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  }

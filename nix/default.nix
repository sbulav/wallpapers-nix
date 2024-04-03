{
  lib,
  stdenv,
  style ? null,
  version,
  ...
}:
stdenv.mkDerivation {
  pname = "wallpapers-nix";
  inherit version;

  strictDeps = true;

  src = ../wallpapers;

  configurePhase = ''
    runHook preConfigure
    mkdir -p $out/share/wallpapers
    runHook postConfigure
  '';

  installPhase = let
    cpIfFull =
      if (style == null)
      then "cp -r ./* $out/share/wallpapers"
      else "cp -r ./${style}* $out/share/wallpapers";
  in ''
    runHook preInstall
    ${cpIfFull}
    runHook postInstall
  '';

  meta = {
    description = "My collection of wallpapers, distributed as Nix package";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}

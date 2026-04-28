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
    styleName =
      if style == null
      then ""
      else style;
    stylePath =
      if style == null
      then ""
      else "./${style}";
  in ''
    runHook preInstall

    if [ -z "${styleName}" ]; then
      cp -r ./* "$out/share/wallpapers"
    else
      if [ ! -d "${stylePath}" ]; then
        echo "wallpaper style '${styleName}' does not exist in $src" >&2
        exit 1
      fi

      cp -r "${stylePath}" "$out/share/wallpapers/"
    fi

    runHook postInstall
  '';

  meta = {
    description = "My collection of wallpapers, distributed as Nix package";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}

{
  description = ''
    A collection of various wallpapers, packed with a Nix Flake
    for easier organization and curation.
    Based on the https://github.com/NotAShelf/wallpkgs
  '';

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs [
      # Add more systems if they are supported
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    pkgsFor = nixpkgs.legacyPackages;

    version = props.version + "_" + (self.shortRev or "dirty");

    props = builtins.fromJSON (builtins.readFile ./nix/props.json);
    wallpaperDirs = builtins.readDir ./wallpapers;
    styles = builtins.attrNames (
      lib.filterAttrs (_: kind: kind == "directory") wallpaperDirs
    );
    mkWallpaperPackage = prev: style:
      prev.callPackage ./nix/default.nix {
        inherit version style;
        stdenv = prev.stdenvNoCC;
      };
  in {
    overlays.default = _: prev: let
      stylePackages = lib.genAttrs styles (mkWallpaperPackage prev);
    in
      stylePackages
      // rec {
        full = wallpkgs;
        wallpkgs = prev.callPackage ./nix/default.nix {
          inherit version;
          stdenv = prev.stdenvNoCC;
          style = null;
        };
      };

    packages = genSystems (system:
      (self.overlays.default null pkgsFor.${system})
      // {
        default = self.packages.${system}.wallpkgs;
      });

    checks = genSystems (system: let
      pkgs = pkgsFor.${system};
      packageSet = self.packages.${system};
    in
      {
        format =
          pkgs.runCommand "wallpapers-nix-format-check" {
            nativeBuildInputs = [pkgs.alejandra];
          } ''
            cd ${self}
            alejandra --check flake.nix nix/*.nix
            touch $out
          '';
      }
      // lib.mapAttrs' (
        name: package:
          lib.nameValuePair "build-${name}" package
      )
      packageSet);

    formatter = genSystems (system: pkgsFor.${system}.alejandra);
  };
}

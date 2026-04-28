# My wallpapers for Nix

Just a bunch of wallpapers packed as Nix package.
Based on the [NotAShelf/wallpkgs](https://github.com/NotAShelf/wallpkgs)

The flake exports:

- `packages.${system}.default`, `packages.${system}.full`, and `packages.${system}.wallpkgs`
- one package per wallpaper directory under `wallpapers/`, currently `catppuccin`, `cities`, `nature`, and `unorganized`
- `overlays.default`

## Building

```console
# Build default (full) package
$ nix build .
```

```console
# Or build only the catppuccin package
$ nix build .#catppuccin
```

## Install

> On NixOS, it's recommended that you add wallpapers-nix to your flake inputs.

```nix
inputs = {
  wallpapers-nix.url = "github:sbulav/wallpapers-nix";
};
```

## Overlay usage

```nix
{
  inputs.wallpapers-nix.url = "github:sbulav/wallpapers-nix";

  outputs = { nixpkgs, wallpapers-nix, ... }: {
    nixosConfigurations.host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ wallpapers-nix.overlays.default ];

          environment.systemPackages = [
            pkgs.wallpkgs
            pkgs.catppuccin
          ];
        })
      ];
    };
  };
}
```

## Using the wallpapers

> The `wallpapers-nix` package moves included wallpapers to `$out/share/wallpapers` by
> default. You may reference those files at `$NIX_USER_PROFILE_DIR/share/wallpapers/${style}`
> if they are installed via `nix profile install` (multi-user Nix), or reference the
> package path if installed via flake inputs with
> `inputs.wallpapers-nix.packages.${pkgs.system}.default` inside NixOS
> configurations.

You can also use a style-specific package directly from the flake outputs:

```nix
{ inputs, pkgs, ... }:
let
  wallpapers = inputs.wallpapers-nix.packages.${pkgs.system}.catppuccin;
in {
  home.packages = [ wallpapers ];
}
```

In this example, wallpapers will be installed to
`$out/share/wallpapers/catppuccin` and only the catppuccin wallpapers will be
included. Using the `default` package will use the full wallpapers directory
and make it available at `$out/share/wallpapers`.

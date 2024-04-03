# My wallpapers for Nix

Just a bunch of wallpapers packed as Nix package.
Based on the [NotAShelf/wallpkgs](https://github.com/NotAShelf/wallpkgs)

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
    wallpapers-nix = "github:sbulav/wallpapers-nix";
};
```

## Using the wallpapers

> The `wallpapers-nix` package moves included wallpapers to `$out/share/wallpapers` by
> default. You may reference those files at `$NIX_USER_PROFILE_DIR/share/wallpapers/${style}`
> if they are installed via `nix profile install` (multi-user Nix), or reference the
> package path if installed via flake inputs with `${pkgs.wallpapers-nix}` inside NixOS
> configurations.

You can also reference the package path with ${pkgs.wallpapers-nix}, optionally providing a style:

```nix
{inputs, ...}:
let
    wallpapers-nix = inputs.wallpapers-nix.packages.${pkgs.system}.catppuccin;
in {
    home.packages = [
        wallpapers-nix
    ];
}
```

In this example, wallpapers will be installed to
`$out/share/wallpapers/catppuccin` and only the catppuccin wallpapers will be
included. Using the `default` package will use the full wallpapers directory
and make it available at `$out/share/wallpapers`.

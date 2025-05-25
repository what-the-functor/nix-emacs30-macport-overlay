# Emacs mac-port v30.1 experimental flake

This flake provides an overlay for [jdtsmith/emacs-mac](https://github.com/jdtsmith/emacs-mac "Experimental emacs-macport v30.1 fork"), based on [nixpkgs PR 393512](https://github.com/NixOS/nixpkgs/pull/393512 "Upstream PR to nixpkgs")

## Usage

Add to your flake inputs.
```nix
inputs = {
  ...
  emacs30-macport-overlay.url = "github:what-the-functor/nix-emacs30-macport-overlay";
}
```

Then add to overlays.
```nix
outputs = {
  ...
  emacs30-macport-overlay
}

overlays = [
  ...
  emacs30-macport-overlay.overlays.default
]
```

{
  description = "Flake providing emacs30-macport from nixpkgs PR 393512";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    emacs30-macport-pkgs.url = "github:NixOS/nixpkgs?rev=e69459daa70f1c496dc5a0142449d894a02ab034";
  };

  outputs =
    {
      self,
      nixpkgs,
      emacs30-macport-pkgs,
    }:
    let
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
        };

      forAllSystems =
        f: nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (system: f { pkgs = (pkgsFor system); });
    in
    {
      overlays = {
        default =
          final: prev:
          let
            pkgs = import emacs30-macport-pkgs { system = prev.system; };
          in
          {
            emacs30-macport = pkgs.emacs30-macport.override { withNativeCompilation = false; };
          };
      };

      packages = forAllSystems (
        { pkgs }:
        {
          emacs30-macport = pkgs.emacs30-macport;
        }
      );
    };
}

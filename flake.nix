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
      dedupe-rpath = ./dedupe-rpath.patch;

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
            pkgs = (import emacs30-macport-pkgs { system = prev.system; }).extend (
              final: prev: {
                ld64 = prev.ld64.overrideAttrs (o: {
                  patches = o.patches ++ [ dedupe-rpath ];
                });
              }
            );

            makeEmacs = import "${pkgs.path}/pkgs/applications/editors/emacs/make-emacs.nix";

            emacs30-macport = makeEmacs {
              pname = "emacs-mac";
              version = "30.1.90";
              variant = "macport";
              src = pkgs.fetchFromGitHub {
                owner = "jdtsmith";
                repo = "emacs-mac";
                rev = "e5514461eb3591778bf63532d0d1cac598c0259d";
                hash = "sha256-AuhOwMQmtS/MmwDFHidfYFKuaqYomEh2Z+Xemdy/zVU=";
              };
              patches = _: [ "${pkgs.path}/pkgs/applications/editors/emacs/macport-stdbool.patch" ];
              meta = {
                homepage = "https://github.com/jdtsmith/emacs-mac";
                platforms = pkgs.lib.platforms.darwin;
              };
            };

          in
          {
            emacs30-macport = pkgs.callPackage emacs30-macport { inherit (pkgs.darwin) sigtool; };
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

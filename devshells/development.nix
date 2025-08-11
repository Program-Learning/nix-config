{
  self,
  forAllSystems,
  nixpkgs,
  ...
}@inputs:
forAllSystems (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    development = pkgs.mkShell {
      packages = with pkgs; [
        # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
        bashInteractive
        # fix `cc` replaced by clang, which causes nvim-treesitter compilation error
        gcc
        # Nix-related
        nixfmt
        deadnix
        statix
        # spell checker
        typos
        # code formatter
        nodePackages.prettier
      ];
      name = "dots";
      shellHook = ''
        ${self.checks.${system}.pre-commit-check.shellHook}
      '';
    };
  }
)

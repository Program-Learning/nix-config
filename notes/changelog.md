# Changelog

## Until 20240410

- Updated to commit:
  [97d675f41172e88f1339513eaff0b84f996e6230](https://github.com/NixOS/nixpkgs/tree/97d675f41172e88f1339513eaff0b84f996e6230)

## pkgs

- `rnix-lsp` is [deprecated](https://github.com/NixOS/nixpkgs/commits/master/pkgs/development/tools/language-servers/rnix-lsp/default.nix)
- `nvtop` updated to `nvtopPackages.full`

## home config

- Changed:
  - `programs.eza.enableAliases` to `programs.eza.enableIonIntegration` +
    `programs.eza.enableZshIntegration` + `programs.eza.enableFishIntegration` +
    `programs.eza.enableBashIntegration` + `programs.eza.enableNushellIntegration`
  - `atuin` is broken. see https://github.com/atuinsh/atuin/issues/1934

## config

- Changed:
  - `programs.gnupg.agent.pinentryFlavor = "curses";` to
    `programs.gnupg.agent.pinentryPackage = pkgs.pinentry-curses;`
- Renamed:
  - `settings.typos` to `hooks.typos.settings`
  - `settings.prettier` to `hooks.prettier.settings`

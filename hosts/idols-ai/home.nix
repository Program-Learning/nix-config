{ config, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  programs.ssh.matchBlocks."github.com".identityFile =
    "${config.home.homeDirectory}/.ssh/y9000k2021h_id_ed25519";

  modules.desktop.nvidia.enable = true;

  modules.desktop.hyprland.settings.source = [
    "${config.home.homeDirectory}/nix-config/hosts/idols-ai/hypr-hardware.conf"
  ];
  xdg.configFile."niri/niri-hardware.kdl".source =
    mkSymlink "${config.home.homeDirectory}/nix-config/hosts/idols-ai/niri-hardware.kdl";
}

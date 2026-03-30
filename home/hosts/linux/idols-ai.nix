{ config, mylib, ... }:
let
  mkSymlink = mylib.mklinkRelativeToRoot;
in
{
  imports = [ ../../linux/gui.nix ];

  programs.ssh.matchBlocks."github.com".identityFile =
    "${config.home.homeDirectory}/.ssh/y9000k2021h_id_ed25519";

  modules.desktop.gaming.enable = true;
  modules.desktop.niri.enable = true;
  modules.desktop.nvidia.enable = true;

  xdg.configFile."niri/niri-hardware.kdl".source =
    mkSymlink config "hosts/idols-ai/niri-hardware.kdl";
}

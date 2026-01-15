{ config, mylib, ... }:
let
  mkSymlink = mylib.mklinkRelativeToRoot;
in
{
  programs.ssh.matchBlocks."github.com".identityFile =
    "${config.home.homeDirectory}/.ssh/y9000k2021h_id_ed25519";

  modules.desktop.nvidia.enable = true;

  xdg.configFile."niri/niri-hardware.kdl".source =
    mkSymlink config "hosts/idols-ai/niri-hardware.kdl";
}

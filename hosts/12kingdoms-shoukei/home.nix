{ config, mylib, ... }:
let
  hostName = "shoukei"; # Define your hostname.
  mkSymlink = mylib.mklinkRelativeToRoot;
in
{
  programs.ssh.matchBlocks."github.com".identityFile =
    "${config.home.homeDirectory}/.ssh/${hostName}";

  modules.desktop.nvidia.enable = false;

  xdg.configFile."niri/niri-hardware.kdl".source =
    mkSymlink config "hosts/12kingdoms-shoukei/niri-hardware.kdl";
}

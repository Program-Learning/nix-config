{
  lib,
  outputs,
}: let
  specialExpected = {
    "ai-kde-wayland" = "ai";
    "ai-gnome-wayland" = "ai";
    "ai-hyprland" = "ai";
    "shoukei-hyprland" = "shoukei";
  };
  specialHostNames = builtins.attrNames specialExpected;

  otherHosts = builtins.removeAttrs outputs.nixosConfigurations specialHostNames;
  otherHostsNames = builtins.attrNames otherHosts;
  # other hosts's hostName is the same as the nixosConfigurations name
  otherExpected = lib.genAttrs otherHostsNames (name: name);
in (specialExpected // otherExpected)

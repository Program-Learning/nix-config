{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "ai-gnome-wayland"
    "ai-kde-wayland"
    "ai-niri"
    "ai-hyprland"
    "shoukei-hyprland"
    "ruby"
    "k3s-prod-1-master-1"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")

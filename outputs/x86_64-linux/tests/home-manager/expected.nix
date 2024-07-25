{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "y9000k2021h-hyprland"
    "y9000k2021h-i3"
    "ai-gnome-wayland"
    "ai-hyprland"
    "ai-i3"
    "shoukei-hyprland"
    "shoukei-i3"
    "ruby"
    "k3s-prod-1-master-1"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")

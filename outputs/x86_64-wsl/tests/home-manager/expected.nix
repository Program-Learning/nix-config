{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "wsl-y9000k2021h-hyprland"
    "wsl-y9000k2021h-i3"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")

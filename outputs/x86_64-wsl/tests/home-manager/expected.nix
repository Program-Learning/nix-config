{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "wsl-y9000k2021h-hyprland"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")

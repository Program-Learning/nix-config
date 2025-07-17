{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "wsl-y9000k2021h"
    "wsl-r9000p2025"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")

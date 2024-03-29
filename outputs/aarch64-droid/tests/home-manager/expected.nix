{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "mondrian"
  ];
in
  lib.genAttrs hosts (_: "/home/${username}")

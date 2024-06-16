{
  myvars,
  lib,
}: let
  username = myvars.username;
  hosts = [
    "mondrian"
  ];
in
  lib.genAttrs hosts (_: "/data/data/com.termux.nix/files/home")

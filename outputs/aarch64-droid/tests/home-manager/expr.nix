{
  myvars,
  lib,
  outputs,
}: let
  username = myvars.username;
  hosts = [
    "mondrian"
  ];
in
  lib.genAttrs
  hosts
  (
    name: outputs.nixOnDroidConfigurations.${name}.config.home-manager.users.${username}.home.homeDirectory
  )

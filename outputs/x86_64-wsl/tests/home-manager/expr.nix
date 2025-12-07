{
  myvars,
  lib,
  outputs,
}:
let
  username = myvars.username;
  hosts = [
    "wsl-y9000p2025"
  ];
in
lib.genAttrs hosts (
  name: outputs.nixosConfigurations.${name}.config.home-manager.users.${username}.home.homeDirectory
)

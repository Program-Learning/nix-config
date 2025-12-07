{
  lib,
  outputs,
}:
let
  specialExpected = {
    "wsl-y9000p2025" = "y9000p2025";
  };
  specialHostNames = builtins.attrNames specialExpected;

  otherHosts = builtins.removeAttrs outputs.nixosConfigurations specialHostNames;
  otherHostsNames = builtins.attrNames otherHosts;
  # other hosts's hostName is the same as the nixosConfigurations name
  otherExpected = lib.genAttrs otherHostsNames (name: name);
in
(specialExpected // otherExpected)

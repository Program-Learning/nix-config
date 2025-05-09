# NOTE: this file is for sops-nix
{
  lib,
  config,
  pkgs,
  sops-nix,
  mysecrets,
  myvars,
  ...
}:
with lib; let
  cfg = config.modules.secrets;

  enabledServerSecrets =
    cfg.server.application.enable
    || cfg.server.network.enable
    || cfg.server.operation.enable
    || cfg.server.kubernetes.enable
    || cfg.server.webserver.enable
    || cfg.server.storage.enable;

  noaccess = {
    mode = "0000";
    owner = "root";
  };
  high_security = {
    mode = "0500";
    owner = "root";
  };
  user_readable = {
    mode = "0500";
    owner = myvars.username;
  };
  MkPermAttr = username: mode: {
    mode = mode;
    owner = username;
  };
in {
  imports = [
    sops-nix.nixosModules.sops
  ];

  config = mkIf (cfg.desktop.enable || enabledServerSecrets) (mkMerge [
    {
      environment.systemPackages = [
        pkgs.sops
      ];

      assertions = [
        {
          # This expression should be true to pass the assertion
          assertion = !(cfg.desktop.enable && enabledServerSecrets);
          message = "Enable either desktop or server's secrets, not both!";
        }
      ];
    }

    (mkIf cfg.desktop.enable {
      })

    (mkIf cfg.server.network.enable {
      })

    (mkIf cfg.server.application.enable {
      })

    (mkIf cfg.server.operation.enable {
      })

    (mkIf cfg.server.kubernetes.enable {
      })

    (mkIf cfg.server.webserver.enable {
      })

    (mkIf cfg.server.storage.enable {
      })
  ]);
}

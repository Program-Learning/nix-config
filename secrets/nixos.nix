# WARN: do not use this file
# Use nixos_agenix.nix or nixos_sopsnix.nix
{
  lib,
  config,
  pkgs,
  agenix,
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
    agenix.nixosModules.default
  ];

  options.modules.secrets = {
    desktop.enable = mkEnableOption "NixOS Secrets for Desktops";

    server.network.enable = mkEnableOption "NixOS Secrets for Network Servers";
    server.application.enable = mkEnableOption "NixOS Secrets for Application Servers";
    server.operation.enable = mkEnableOption "NixOS Secrets for Operation Servers(Backup, Monitoring, etc)";
    server.kubernetes.enable = mkEnableOption "NixOS Secrets for Kubernetes";
    server.webserver.enable = mkEnableOption "NixOS Secrets for Web Servers(contains tls cert keys)";
    server.storage.enable = mkEnableOption "NixOS Secrets for HDD Data's LUKS Encryption";

    impermanence.enable = mkEnableOption "whether use impermanence and ephemeral root file system";
  };

  config = mkIf (cfg.desktop.enable || enabledServerSecrets) (mkMerge [
    {
      environment.systemPackages = [
        agenix.packages."${pkgs.system}".default
      ];

      # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
      age.identityPaths =
        if cfg.impermanence.enable
        then [
          # To decrypt secrets on boot, this key should exists when the system is booting,
          # so we should use the real key file path(prefixed by `/persistent/`) here, instead of the path mounted by impermanence.
          "/persistent/etc/ssh/ssh_host_ed25519_key" # Linux
        ]
        else [
          "/etc/ssh/ssh_host_ed25519_key"
        ];

      # secrets that are used by all nixos hosts
      age.secrets = {
        "nix-access-tokens" =
          {
            file = "${mysecrets}/nix-access-tokens.age";
          }
          # access-token needs to be readable by the user running the `nix` command
          // user_readable;
      };

      assertions = [
        {
          # This expression should be true to pass the assertion
          # WARNING: we bypass this on my secret bcs we only have a computer without surrounding facilities
          assertion = !(cfg.desktop.enable && enabledServerSecrets) || true;
          message = "Enable either desktop or server's secrets, not both!";
        }
      ];
    }

    (mkIf cfg.desktop.enable {
      age.secrets = {
        # ---------------------------------------------
        # no one can read/write this file, even root.
        # ---------------------------------------------

        # .age means the decrypted file is still encrypted by age(via a passphrase)
        "nix-gpg-subkeys.priv.age" =
          {
            file = "${mysecrets}/nix-gpg-subkeys-2024-01-27.priv.age.age";
          }
          // noaccess;

        # ---------------------------------------------
        # only root can read this file.
        # ---------------------------------------------

        "wg-business.conf" =
          {
            file = "${mysecrets}/wg-business.conf.age";
          }
          // high_security;

        # Used only by NixOS Modules
        # smb-credentials is referenced in /etc/fstab, by ../hosts/ai/cifs-mount.nix
        "smb-credentials" =
          {
            file = "${mysecrets}/smb-credentials.age";
          }
          // high_security;

        "rclone.conf" =
          {
            file = "${mysecrets}/rclone.conf.age";
          }
          // high_security;

        # ---------------------------------------------
        # user can read this file.
        # ---------------------------------------------

        "ssh-key-romantic" =
          {
            file = "${mysecrets}/ssh-key-romantic.age";
          }
          // user_readable;

        "gluttony" =
          {
            file = "${mysecrets}/gluttony.age";
          }
          // user_readable;

        "juliet-age" =
          {
            file = "${mysecrets}/juliet-age.age";
          }
          // user_readable;

        "y9000k2021h_id_rsa" =
          {
            file = "${mysecrets}/y9000k2021h_id_rsa.age";
          }
          // user_readable;

        "y9000k2021h_id_ed25519" =
          {
            file = "${mysecrets}/y9000k2021h_id_ed25519.age";
          }
          // user_readable;

        # alias-for-work
        "alias-for-work.nushell" =
          {
            file = "${mysecrets}/alias-for-work.nushell.age";
          }
          // user_readable;

        "alias-for-work.bash" =
          {
            file = "${mysecrets}/alias-for-work.bash.age";
          }
          // user_readable;
        # I do not have server for router request so I use dae locally
        "clash.dae" =
          {
            file = "${mysecrets}/clash.dae.age";
          }
          // high_security;
        "dae.dae" =
          {
            file = "${mysecrets}/dae.dae.age";
          }
          // high_security;
        "dae-subscription.dae" =
          {
            file = "${mysecrets}/server/dae-subscription.dae.age";
          }
          // high_security;
        "cpolar.yml" =
          {
            file = "${mysecrets}/cpolar.yml.age";
          }
          // (MkPermAttr "cpolar" "0700");
        "alist-jwt" =
          {
            file = "${mysecrets}/alist-jwt.age";
          }
          // (MkPermAttr "alist" "0700");
      };

      # place secrets in /etc/
      environment.etc = {
        # wireguard config used with `wg-quick up wg-business`
        "wireguard/wg-business.conf" = {
          source = config.age.secrets."wg-business.conf".path;
        };

        "agenix/rclone.conf" = {
          source = config.age.secrets."rclone.conf".path;
        };

        "agenix/ssh-key-romantic" = {
          source = config.age.secrets."ssh-key-romantic".path;
          mode = "0600";
          user = myvars.username;
        };

        "agenix/gluttony" = {
          source = config.age.secrets."gluttony".path;
          mode = "0600";
          user = myvars.username;
        };

        "agenix/juliet-age" = {
          source = config.age.secrets."juliet-age".path;
          mode = "0600";
          user = myvars.username;
        };

        "agenix/y9000k2021h_id_rsa" = {
          source = config.age.secrets."y9000k2021h_id_rsa".path;
          mode = "0600";
          user = myvars.username;
        };

        "agenix/y9000k2021h_id_ed25519" = {
          source = config.age.secrets."y9000k2021h_id_ed25519".path;
          mode = "0600";
          user = myvars.username;
        };

        "agenix/nix-gpg-subkeys.priv.age" = {
          source = config.age.secrets."nix-gpg-subkeys.priv.age".path;
          mode = "0000";
        };

        # The following secrets are used by home-manager modules
        # So we need to make then readable by the user
        "agenix/alias-for-work.nushell" = {
          source = config.age.secrets."alias-for-work.nushell".path;
          mode = "0644"; # both the original file and the symlink should be readable and executable by the user
        };
      };
    })

    (mkIf cfg.server.network.enable {
      age.secrets = {
        "dae-subscription.dae" =
          {
            file = "${mysecrets}/server/dae-subscription.dae.age";
          }
          // high_security;
      };
    })

    (mkIf cfg.server.application.enable {
      age.secrets = {
        "transmission-credentials.json" =
          {
            file = "${mysecrets}/server/transmission-credentials.json.age";
          }
          // high_security;

        "sftpgo.env" = {
          file = "${mysecrets}/server/sftpgo.env.age";
          mode = "0400";
          owner = "sftpgo";
        };
        "minio.env" = {
          file = "${mysecrets}/server/minio.env.age";
          mode = "0400";
          owner = "minio";
        };
      };
    })

    (mkIf cfg.server.operation.enable {
      age.secrets = {
        "grafana-admin-password" = {
          file = "${mysecrets}/server/grafana-admin-password.age";
          mode = "0400";
          owner = "grafana";
        };

        "alertmanager.env" =
          {
            file = "${mysecrets}/server/alertmanager.env.age";
          }
          // high_security;
      };
    })

    (mkIf cfg.server.kubernetes.enable {
      age.secrets = {
        "k3s-prod-1-token" =
          {
            file = "${mysecrets}/server/k3s-prod-1-token.age";
          }
          // high_security;

        "k3s-test-1-token" =
          {
            file = "${mysecrets}/server/k3s-test-1-token.age";
          }
          // high_security;
      };
    })

    (mkIf cfg.server.webserver.enable {
      age.secrets = {
        "caddy-ecc-server.key" = {
          file = "${mysecrets}/certs/ecc-server.key.age";
          mode = "0400";
          owner = "caddy";
        };
        "postgres-ecc-server.key" = {
          file = "${mysecrets}/certs/ecc-server.key.age";
          mode = "0400";
          owner = "postgres";
        };
      };
    })

    (mkIf cfg.server.storage.enable {
      age.secrets = {
        "hdd-luks-crypt-key" = {
          file = "${mysecrets}/hdd-luks-crypt-key.age";
          mode = "0400";
          owner = "root";
        };
      };

      # place secrets in /etc/
      environment.etc = {
        "agenix/hdd-luks-crypt-key" = {
          source = config.age.secrets."hdd-luks-crypt-key".path;
          mode = "0400";
          user = "root";
        };
      };
    })
  ]);
}

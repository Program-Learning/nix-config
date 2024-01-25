# https://github.com/LongerHV/nixos-configuration/blob/c7a06a2125673c472946cda68b918f68c635c41f/modules/nixos/sunshine.nix
# https://github.com/RandomNinjaAtk/nixos/blob/fc7d6e8734e6de175e0a18a43460c48003108540/services.sunshine.nix
# First import me
# Enable using:
# features.sunshine.enable = true;
# Get Service Status
# systemctl --user status sunshine
# get logs
# journalctl --user -u sunshine --since "2 minutes ago"
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.sunshine;
in {
  options.features.sunshine = with lib; {
    enable = mkEnableOption "sunshine";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPortRanges = [
      {
        from = 47984;
        to = 48010;
      }
      {
        from = 9992;
        to = 9994;
      }
    ];
    networking.firewall.allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48010;
      }
      {
        from = 9992;
        to = 9994;
      }
    ];
    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };
    # Requires to simulate input
    boot.kernelModules = ["uinput"];
    services.udev.extraRules = ''
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    '';
    systemd.user.services.sunshine = {
      description = "Sunshine self-hosted game stream host for Moonlight";
      startLimitBurst = 5;
      startLimitIntervalSec = 500;
      serviceConfig = {
        ExecStart = "${config.security.wrapperDir}/sunshine";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}

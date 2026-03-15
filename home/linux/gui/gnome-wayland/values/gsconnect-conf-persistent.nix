{ config, pkgs, ... }:
{
  # https://github.com/jz8132543/flakes/blob/3225d8f726da9a8980a7becc949f3f634927f926/home-manager/modules/desktop/gnome.nix#L293-L321
  # NOTE: make sure dumpped gsconnect.dconf is persistent if you are using tmpfs as root
  systemd.user.services.gsconnect-dconf = {
    Unit = {
      Description = "gsconnect-dconf";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = toString (
        pkgs.writeScript "gsconnect-dconf-start" ''
          #! ${pkgs.runtimeShell} -el
          ${pkgs.dconf}/bin/dconf load /org/gnome/shell/extensions/gsconnect/ < ${config.home.homeDirectory}/.config/gsconnect/gsconnect.dconf || true
        ''
      );
      ExecStop = toString (
        pkgs.writeScript "gsconnect-dconf-stop" ''
          #! ${pkgs.runtimeShell} -el
          ${pkgs.dconf}/bin/dconf dump /org/gnome/shell/extensions/gsconnect/ > ${config.home.homeDirectory}/.config/gsconnect/gsconnect.dconf
        ''
      );
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      RemainAfterExit = "yes";
    };
  };
}

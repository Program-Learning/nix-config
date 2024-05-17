{
  config,
  lib,
  pkgs,
  ...
}: let
  clash_version = "clash-nyanpasu";
in {
  options.programs."${clash_version}" = {
    enable = lib.mkEnableOption (lib.mdDoc "Clash");
    package = lib.mkPackageOption pkgs "${clash_version}" {};
    autoStart = lib.mkEnableOption (lib.mdDoc "Clash auto launch");
    tunMode = lib.mkEnableOption (lib.mdDoc "Clash TUN mode");
  };

  config = let
    cfg = config.programs."${clash_version}";
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem {
          name = cfg.package.pname;
          package = cfg.package;
        }))
      ];

      security.wrappers."${cfg.package.pname}" = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe cfg.package}";
      };
    };

  meta.maintainers = with lib.maintainers; [zendo];
}

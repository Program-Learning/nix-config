{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.nekoray = {
    enable = lib.mkEnableOption (lib.mdDoc "nekoray");
    package = lib.mkPackageOption pkgs "nekoray" {};
    autoStart = lib.mkEnableOption (lib.mdDoc "nekoray auto launch");
    tunMode = lib.mkEnableOption (lib.mdDoc "nekoray TUN mode");
  };

  config = let
    cfg = config.programs.nekoray;
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

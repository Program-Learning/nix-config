{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features.nekoray = {
    enable = lib.mkEnableOption (lib.mdDoc "nekoray");
    package = lib.mkPackageOption pkgs "nekoray" {};
    autoStart = lib.mkEnableOption (lib.mdDoc "nekoray auto launch");
    tunMode = lib.mkEnableOption (lib.mdDoc "nekoray TUN mode");
  };

  config = let
    cfg = config.features.nekoray;
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem {
          name = cfg.package.pname;
          package = cfg.package;
        }))
      ];

      security.wrappers.nekoray_core = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${cfg.package}/share/nekoray/nekoray_core";
      };

      security.wrappers.nekobox_core = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${cfg.package}/share/nekoray/nekobox_core";
      };
    };

  meta.maintainers = with lib.maintainers; [zendo];
}

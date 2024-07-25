{
  config,
  lib,
  pkgs,
  ...
}: let
  pkg_name = "intel-gpu-tools";
in {
  options.features."${pkg_name}" = {
    enable = lib.mkEnableOption (lib.mdDoc "${pkg_name}");
    package = lib.mkPackageOption pkgs "${pkg_name}" {};
    autoStart = lib.mkEnableOption (lib.mdDoc "${pkg_name} auto launch");
    enhanceMode = lib.mkEnableOption (lib.mdDoc "${pkg_name} enhanceMode mode");
  };

  config = let
    cfg = config.features."${pkg_name}";
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem {
          name = cfg.package.pname;
          package = cfg.package;
        }))
      ];

      security.wrappers = lib.mkIf cfg.enhanceMode {
        intel_gpu_top = {
          owner = "root";
          group = "root";
          capabilities = "cap_perfmon+p";
          source = "${cfg.package}/bin/intel_gpu_top";
        };
      };
    };

  meta.maintainers = with lib.maintainers; [zendo];
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  pkg_name = "lenovo-legion";
in
{
  options.features."${pkg_name}" = {
    enable = lib.mkEnableOption (lib.mdDoc "${pkg_name}");
    package = lib.mkPackageOption pkgs "${pkg_name}" { };
    autoStart = lib.mkEnableOption (lib.mdDoc "${pkg_name} auto launch");
    enhanceMode = lib.mkEnableOption (lib.mdDoc "${pkg_name} enhanceMode mode");
    installKernelModule = lib.mkEnableOption (lib.mdDoc "${pkg_name} installKernelModule");
  };

  config =
    let
      cfg = config.features."${pkg_name}";
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (
          pkgs.makeAutostartItem {
            name = cfg.package.pname;
            package = cfg.package;
          }
        ))
      ];

      security.wrappers = lib.mkIf cfg.enhanceMode {
        legion_gui_with_cap = {
          owner = "root";
          group = "root";
          capabilities = "cap_dac_override,cap_dac_read_search,cap_sys_rawio,cap_sys_admin+p";
          # setuid = true;
          source = "${pkgs.lenovo-legion}/bin/legion_gui";
        };
      };
      boot.extraModulePackages = lib.mkIf cfg.installKernelModule [
        config.boot.kernelPackages.lenovo-legion-module
      ];
    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}

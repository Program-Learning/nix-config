{
  config,
  pkgs,
  lib,
  ...
}: {
  #security.wrappers.warp-svc = {
  #  owner = "root";
  #  group = "root";
  #  capabilities = "cap_net_bind_service,cap_net_raw,cap_net_admin,cap_dac_override+p";
  #  source = "${pkgs.cloudflare-warp}/bin/warp-svc";
  #};
  security.wrappers = {
    intel_gpu_top = {
      owner = "root";
      group = "root";
      capabilities = "cap_perfmon+p";
      source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
    };

    legion_gui_with_cap = {
      owner = "root";
      group = "root";
      capabilities = "cap_dac_override,cap_dac_read_search,cap_sys_rawio,cap_sys_admin+p";
      # setuid = true;
      source = "${pkgs.lenovo-legion}/bin/legion_gui";
    };
  };
}

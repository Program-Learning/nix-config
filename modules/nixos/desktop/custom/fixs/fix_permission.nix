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
}

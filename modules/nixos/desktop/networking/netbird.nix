{
  config,
  pkgs,
  ...
}:
# =============================================================
#
# Netbird - your own private network(VPN)
#
# It's open source and free for personal use,
# and it's really easy to setup and use.
# Netbird has great client coverage for Linux, windows, Mac, android, and iOS.
{
  services.netbird.enable = true;
}

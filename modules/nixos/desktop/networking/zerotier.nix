{
  config,
  pkgs,
  ...
}:
# =============================================================
#
# Zerotier - your own private network(VPN)
#
# It's open source and free for personal use,
# and it's really easy to setup and use.
# Zerotier has great client coverage for Linux, windows, Mac, android, and iOS.
# Zerotier is more mature and stable compared to other alternatives such as netbird/netmaker.
# Maybe I'll give netbird/netmaker a try when they are more mature, but for now, I'm sticking with Zerotier.
{
  # make the zerotier command usable to users
  environment.systemPackages = [ pkgs.zerotierone ];

  # enable the zerotierone service
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "c7c8172af18872cd"
    ];
  };
}

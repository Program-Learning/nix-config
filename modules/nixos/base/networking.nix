_: {
  # Network discovery, mDNS
  # With this enabled, you can access your machine at <hostname>.local
  # it's more convenient than using the IP address.
  # https://avahi.org/
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };
  networking.networkmanager.wifi.macAddress = "be:fc:85:71:a4:c0";
  networking.networkmanager.ethernet.macAddress = "be:fc:85:71:a4:c0";
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    dbeaver-bin # database manager
    gg # proxy agent in terminal
    mitmproxy # http/https proxy tool
    bettercap # mitm proxy tool
    whistle # HTTP, HTTP2, HTTPS, Websocket debugging proxy
    # charles # Web Debugging Proxy
    insomnia # REST client
    hoppscotch # Api Test Tool
    wireshark # network analyzer
    linux-wifi-hotspot
    hostapd

    # IDEs
    jetbrains.idea-community
    # jetbrains.idea-ultimate
    # eclipses.eclipse-sdk
    eclipses.eclipse-jee
  ];
}

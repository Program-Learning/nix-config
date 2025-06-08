{pkgs, ...}: {
  home.packages = with pkgs; [
    dbeaver-bin # database manager
    # TODO: move tui network tools to a better place
    traceroute # trace route
    gg # proxy agent in terminal
    mitmproxy # http/https proxy tool
    bettercap # mitm proxy tool
    whistle # HTTP, HTTP2, HTTPS, Websocket debugging proxy
    # charles # Web Debugging Proxy
    insomnia # REST client
    hoppscotch # Api Test Tool
    wireshark # network analyzer
    ciscoPacketTracer8 # computer network tool
    # these is gns3, an alternative to packet tracer
    # gns3-server
    # gns3-gui
    linux-wifi-hotspot
    hostapd

    # IDEs
    # jetbrains.idea-community
    jetbrains.idea-community
    # jetbrains.idea-ultimate
    # eclipses.eclipse-sdk
    eclipses.eclipse-jee
  ];
}

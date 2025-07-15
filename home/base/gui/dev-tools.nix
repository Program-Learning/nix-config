{
  pkgs,
  nur-ryan4yin,
  ...
}: {
  home.packages = with pkgs;
    [
      dbeaver-bin # database manager
      # TODO: move tui network tools to a better place
      traceroute # trace route
      gg # proxy agent in terminal
      bettercap # mitm proxy tool
      whistle # HTTP, HTTP2, HTTPS, Websocket debugging proxy
      insomnia # REST client
      hoppscotch # Api Test Tool
      ciscoPacketTracer8 # computer network tool
      # these is gns3, an alternative to packet tracer
      # gns3-server
      # gns3-gui
      linux-wifi-hotspot
      hostapd

      mitmproxy # http/https proxy tool
      wireshark # network analyzer

      # IDEs
      # jetbrains.idea-community

      # AI cli tools
      nur-ryan4yin.packages.${pkgs.system}.gemini-cli
      k8sgpt
      kubectl-ai # an ai helper opensourced by google
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      insomnia # REST client
    ])
    ++ [
      jetbrains.idea-community
      # jetbrains.idea-ultimate
      # eclipses.eclipse-sdk
      eclipses.eclipse-jee
    ];
}

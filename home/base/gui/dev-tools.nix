{pkgs, ...}: {
  home.packages = with pkgs; [
    dbeaver-bin # database manager
    mitmproxy # http/https proxy tool
    whistle # HTTP, HTTP2, HTTPS, Websocket debugging proxy
    # charles # Web Debugging Proxy
    insomnia # REST client
    wireshark # network analyzer
    hoppscotch # Api Test Tool
  ];
}

{
  pkgs-stable,
  pkgs,
  nur-program-learning,
  ...
}: {
  home.packages = with pkgs; [
    # db related
    dbeaver

    mitmproxy # http/https proxy tool
    insomnia # REST client
    wireshark # network analyzer
    # hoppscotch is not in nixpkgs now
    # hoppscotch # Api Test Tool

  ];
}

{
  config,
  mylib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    clash-meta
  ];

  home.file.".proxychains/proxychains.conf".source = mylib.mklink config "home/darwin/proxy/proxychains.conf";
}

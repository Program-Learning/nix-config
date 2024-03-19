{
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
    ventoy # create bootable usb
    virt-viewer # vnc connect to VM, used by kubevirt
    etcher
    baobab # Graphical disk usage analyzer

    # hoppscotch is not in nixpkgs now
    # hoppscotch # Api Test Tool

    # nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_appimage
    nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_bin

  ];
}

{
  pkgs,
  nur-ryan4yin,
  nur-DataEraserC,
  ...
}:
{
  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      # for flypy chinese input method
      fcitx5-rime
      # needed enable rime using configtool after installed
      qt6Packages.fcitx5-configtool
      qt6Packages.fcitx5-chinese-addons # we use rime instead
      # fcitx5-mozc    # japanese input method
      fcitx5-gtk # gtk im module
      fcitx5-material-color
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
      nur-DataEraserC.packages.${pkgs.system}.fcitx5-pinyin-CustomPinyinDictionary
    ];
  };
}

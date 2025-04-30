{
  pkgs,
  lib,
  config,
  ...
}: {
  nix.settings.substituters = ["https://mirrors.ustc.edu.cn/nix-channels/store" "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
  nix.package = pkgs.nix;
}

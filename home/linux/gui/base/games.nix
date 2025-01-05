{
  pkgs,
  pkgs-latest,
  nix-gaming,
  ...
}: {
  home.packages = with pkgs; [
    # nix-gaming.packages.${pkgs.system}.osu-laser-bin
    gamescope # SteamOS session compositing window manager
    prismlauncher # A free, open source launcher for Minecraft

    # --wine
    protonup-qt
    # wine-staging
    wine64Packages.stagingFull
    # winePackages.stagingFull
    winetricks # A script to install DLLs needed to work around problems in Wine
    # proton-ge-bin should not be installed into environments. Please use programs.steam.extraCompatPackages instead.
    playonlinux
    bottles
    lutris

    onscripter-en
  ];
}

{
  pkgs,
  pkgs-stable,
  pkgs-latest,
  nix-gaming,
  pkgs-unstable-yuzu,
  suyu,
  ...
}: {
  home.packages = with pkgs; [
    # nix-gaming.packages.${pkgs.system}.osu-stable
    nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    gamescope # SteamOS session compositing window manager
    # prismlauncher # A free, open source launcher for Minecraft
    hmcl # MineCraft Launcher
    # minecraft # Official MineCraft Launcher
    # prismlauncher

    mindustry-wayland
    #mindustry-server

    # Wine related
    protonup-qt
    wineWow64Packages.waylandFull
    # wine-staging
    # wine64Packages.stagingFull
    # winePackages.stagingFull
    winetricks # A script to install DLLs needed to work around problems in Wine
    # proton-ge-bin should not be installed into environments. Please use programs.steam.extraCompatPackages instead.
    # playonlinux
    bottles
    lutris

    # Switch related
    pkgs-unstable-yuzu.yuzu # Switch games
    # broken so I disable it
    suyu.packages.${pkgs.system}.suyu # Switch games
    ryujinx # Switch games

    # Steam related
    steamcmd # steam command line

    # Ons related
    onscripter-en
  ];
}

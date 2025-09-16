{
  pkgs,
  nix-gaming,
  pkgs-unstable-yuzu,
  suyu,
  aagl,
  ...
}:
{
  # ==========================================================================
  # Gaming on Linux
  #
  #   <https://www.protondb.com/> can give you an idea what works where and how.
  #   Begineer Guide: <https://www.reddit.com/r/linux_gaming/wiki/faq/>
  # ==========================================================================

  # Games installed by Steam works fine on NixOS, no other configuration needed.
  programs.steam = {
    # Some location that should be persistent:
    #   ~/.local/share/Steam - The default Steam install location
    #   ~/.local/share/Steam/steamapps/common - The default Game install location
    #   ~/.steam/root        - A symlink to ~/.local/share/Steam
    #   ~/.steam             - Some Symlinks & user info
    enable = pkgs.stdenv.isx86_64;
    # https://github.com/ValveSoftware/gamescope
    # Run a GameScope driven Steam session from your display-manager
    # fix resolution upscaling and stretched aspect ratios
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
    # https://github.com/Winetricks/winetricks
    # Whether to enable protontricks, a simple wrapper for running Winetricks commands for Proton-enabled games.
    protontricks.enable = true;
    # Whether to enable Load the extest library into Steam, to translate X11 input events to uinput events (e.g. for using Steam Input on Wayland) .
    extest.enable = true;
    fontPackages = [
      pkgs.wqy_zenhei # Need by steam for Chinese
    ];
  };

  # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
  services.pipewire.lowLatency.enable = true;
  programs.steam.platformOptimizations.enable = true;
  imports = with nix-gaming.nixosModules; [
    pipewireLowLatency
    platformOptimizations

  environment.systemPackages = with pkgs; [
    # run anime games on Linux
    aagl.nixosModules.default
    # https://github.com/flightlessmango/MangoHud
    # a simple overlay program for monitoring FPS, temperature, CPU and GPU load, and more.
    mangohud
    # a GUI game launcher for Steam/GoG/Epic
    lutris
    bottles

    nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    # nix-gaming.packages.${pkgs.system}.osu-stable
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
    # proton-ge-bin should not be installed into environments. Please use programs.steam.extraCompatPackages instead.
    # playonlinux

    # Switch related
    pkgs-unstable-yuzu.yuzu # Switch games
    # broken so I disable it
    suyu.packages.${pkgs.system}.suyu # Switch games
    ryubing # Switch games

    # Steam related
    steamcmd # steam command line

    # Ons related
    onscripter-en
  ];

  # Optimise Linux system performance on demand
  # https://github.com/FeralInteractive/GameMode
  # https://wiki.archlinux.org/title/Gamemode
  #
  # Usage:
  #   1. For games/launchers which integrate GameMode support:
  #      https://github.com/FeralInteractive/GameMode#apps-with-gamemode-integration
  #      simply running the game will automatically activate GameMode.
  programs.gamemode.enable = pkgs.stdenv.isx86_64;

  # run anime games on Linux
  # https://github.com/an-anime-team/
  programs.anime-game-launcher.enable = true; # Genshin: Impact
  programs.honkers-railway-launcher.enable = true; # Honkai: Star Rail
  programs.honkers-launcher.enable = false; # Honkai: Impact 3
  programs.sleepy-launcher.enable = false; # Zenless Zon Zero
}

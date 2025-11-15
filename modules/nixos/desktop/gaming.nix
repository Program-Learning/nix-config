{
  pkgs,
  pkgs-x64,
  nix-gaming,
  aagl,
  config,
  lib,
  pkgs-unstable-yuzu,
  suyu,
  linyaps-flake,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.gaming;
in
{
  imports = [
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations

    # run anime games on Linux
    aagl.nixosModules.default

    # Linyaps
    # linyaps-flake.nixosModules.linyaps
  ];

  options.modules.desktop = {
    gaming = {
      enable = mkEnableOption "Install Game Suite(steam, lutris, etc (Also some important runtimes))";
    };
  };

  config = mkIf cfg.enable {
    # ==========================================================================
    # Gaming on Linux
    #
    #   <https://www.protondb.com/> can give you an idea what works where and how.
    #   Begineer Guide: <https://www.reddit.com/r/linux_gaming/wiki/faq/>
    # ==========================================================================

    # Games installed by Steam works fine on NixOS, no other configuration needed.
    # https://github.com/NixOS/nixpkgs/blob/master/doc/packages/steam.section.md
    programs.steam = {
      # Some location that should be persistent:
      #   ~/.local/share/Steam - The default Steam install location
      #   ~/.local/share/Steam/steamapps/common - The default Game install location
      #   ~/.steam/root        - A symlink to ~/.local/share/Steam
      #   ~/.steam             - Some Symlinks & user info
      enable = true;
      package = pkgs-x64.steam;
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

    # Optimise Linux system performance on demand
    # https://github.com/FeralInteractive/GameMode
    # https://wiki.archlinux.org/title/Gamemode
    #
    # Usage:
    #   1. For games/launchers which integrate GameMode support:
    #      https://github.com/FeralInteractive/GameMode#apps-with-gamemode-integration
    #      simply running the game will automatically activate GameMode.
    programs.gamemode.enable = true;

    # run anime games on Linux
    # https://github.com/an-anime-team/
    networking.mihoyo-telemetry.block = true;
    environment.systemPackages =
      with aagl.packages."x86_64-linux";
      [
        anime-game-launcher # Genshin: Impact
        honkers-railway-launcher # Honkai: Star Rail
        sleepy-launcher # Zenless Zon Zero
      ]
      ++
        # Mayuri Spec
        (with pkgs; [
          nix-gaming.packages.${pkgs.system}.osu-lazer-bin
          # nix-gaming.packages.${pkgs.system}.osu-stable
          # prismlauncher # A free, open source launcher for Minecraft
          hmcl # MineCraft Launcher
          # minecraft # Official MineCraft Launcher
          # prismlauncher

          mindustry-wayland
          #mindustry-server
        ]);
    # Linyaps
    services.linyaps.enable = true;
  };
}

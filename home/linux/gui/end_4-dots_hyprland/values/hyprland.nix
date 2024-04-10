{
  pkgs,
  lib,
  hyprland,
  hyprland-plugins,
  nur-ryan4yin,
  end_4-dots_hyprland,
  ...
}: let
  mkRootPath = f: /. + "${f}";
  mkXdgConfigFile = RootPath: f: {
    "${f}" = {
      source = mkRootPath "${RootPath}/${f}";
      recursive = true;
    };
  };
  plugins = hyprland-plugins.packages.${pkgs.system};

  launcher = pkgs.writeShellScriptBin "hypr" ''
    #!/${pkgs.bash}/bin/bash

    export WLR_NO_HARDWARE_CURSORS=1
    export _JAVA_AWT_WM_NONREPARENTING=1

    exec ${hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland
  '';
in {
  home.packages = with pkgs; [
    launcher
    adoptopenjdk-jre-bin
    # jdk17
  ];

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  programs = {
    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
    };
  };
  # NOTE:
  # We have to enable hyprland/i3's systemd user service in home-manager,
  # so that gammastep/wallpaper-switcher's user service can be start correctly!
  # they are all depending on hyprland/i3's user graphical-session
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = "${nur-ryan4yin.packages.${pkgs.system}.catppuccin-hyprland}/themes/mocha.conf";
      env = [
        "NIXOS_OZONE_WL,1" # for any ozone-based browser & electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND,1" # for firefox to run on wayland
        "MOZ_WEBRENDER,1"
        # misc
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland"
      ];
    };
    package = hyprland.packages.${pkgs.system}.hyprland;
    extraConfig = builtins.replaceStrings ["~"] ["${end_4-dots_hyprland}"] (builtins.readFile "${end_4-dots_hyprland}/.config/hypr/hyprland.conf");
    plugins = [
      # hyprland-plugins.packages.${pkgs.system}.hyprbars
      # ...
    ];
    # gammastep/wallpaper-switcher need this to be enabled.
    systemd.enable = true;
  };
  xdg.configFile.".config/hypr/hyprland.conf".enable = false;

  # NOTE: this executable is used by greetd to start a wayland session when system boot up
  # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
  home.file.".wayland-session" = {
    source = "${pkgs.hyprland}/bin/Hyprland";
    executable = true;
  };
}

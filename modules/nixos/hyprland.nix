{pkgs, username, hyprland, ...}: {
  ##########################################################################################################
  #
  #  NixOS's Configuration for Wayland based Window Manager
  #
  #    hyprland: project starts from 2022, support Wayland, envolving fast, good looking, support Nvidia GPU.
  #
  ##########################################################################################################

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      # xdg-desktop-portal-hyprland
    ];
  };

  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
        # autologin
        initial_session = {
          command = "Hyprland";
          user = username;
        };
      };
    };

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
        # gnome.enable = true;
      };

      displayManager = {
        defaultSession = "hyprland";
        lightdm.enable = false;
        sddm.enable = false;
        # # use bash to launch Hyprland since gdm can not work properly in my computer due to unknown reason (or switch to other tty to avoid problem)
        # # use bash instead of nu since https://github.com/ryan4yin/nix-config/issues/8 (https://github.com/nix-community/home-manager/issues/3100#issuecomment-1193140322) (maybe)
        # gdm = {
        #   enable = true;
        #   wayland = true;
        #   debug = true;
        #   settings = {
        #     debug = {
        #       enable = true;
        #     };
        #   };
        # };
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland.override {
        enableXWayland = true; # whether to enable XWayland
        legacyRenderer = false; # whether to use the legacy renderer (for old GPUs)
        withSystemd = true; # whether to build with systemd support
      };
    };

    # thunar file manager(part of xfce) related options
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
  };
    # Terminal fix:
    # In Thunar Edit>Configure custom actions... then edit "Open Terminal Here"
    # wezterm start --cwd %f

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    wl-clipboard # copying and pasting
    hyprpicker # color picker

    wf-recorder # creen recording
    grim # taking screenshots
    slurp # selecting a region to screenshot
    # TODO replace by `flameshot gui --raw | wl-copy`

    mako # the notification daemon, the same as dunst

    yad # a fork of zenity, for creating dialogs

    # audio
    alsa-utils # provides amixer/alsamixer/...
    kew # terminal music player
    mpd # for playing system sounds
    mpc-cli # command-line mpd client
    ncmpcpp # a mpd client with a UI
    vimpc # A curses mpd client with vi-like key bindings.
    networkmanagerapplet # provide GUI app: nm-connection-editor
  ];

  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = {};
}

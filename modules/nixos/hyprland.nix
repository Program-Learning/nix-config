{pkgs, username, hyprland, ...}: {
  ##########################################################################################################
  #
  #  NixOS's Configuration for Hyprland Window Manager
  #
  #    i3wm: old and stable, only support X11
  #    sway: compatible with i3wm, support Wayland. do not support Nvidia GPU officially.
  #    hyprland: project starts from 2022, support Wayland, envolving fast, good looking, support Nvidia GPU.
  #
  ##########################################################################################################

  imports = [
     # hyprland.nixosModules.default
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
    ];
  };

  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
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
        #initial_session = {
        #  command = "Hyprland";
        #  user = username;
        #};
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
    
      xwayland = {
        enable = true;
        hidpi = false;
      };
    
      nvidiaPatches = true;
    };

    # monitor backlight control
    light.enable = true;

    # thunar file manager(part of xfce) related options
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    wl-clipboard # copying and pasting
    hyprpicker  # color picker

    wf-recorder # creen recording
    grim # taking screenshots
    slurp # selecting a region to screenshot
    # TODO replace by `flameshot gui --raw | wl-copy`

    mako # the notification daemon, the same as dunst

    yad # a fork of zenity, for creating dialogs

    # audio
    alsa-utils # provides amixer/alsamixer/...
    mpd # for playing system sounds
    mpc-cli # command-line mpd client
    ncmpcpp # a mpd client with a UI
    vimpc # A curses mpd client with vi-like key bindings.
    networkmanagerapplet # provide GUI app: nm-connection-editor

    xfce.thunar # xfce4's file manager
    # Terminal fix:
    # In Thunar Edit>Configure custom actions... then edit "Open Terminal Here"
    # wezterm start --cwd %f
  ];

  # fix https://github.com/ryan4yin/nix-config/issues/10
  security.pam.services.swaylock = {};
}

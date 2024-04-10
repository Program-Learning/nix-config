{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs;
  with nodePackages_latest;
  with gnome;
  with libsForQt5;
    [
      xorg.xhost # to fix sudo graphical application
      brightnessctl # a tool to set screen brightness
      wev # debug which key is pressed
      waybar # the status bar
      swaybg # the wallpaper
      linux-wallpaperengine # A video wallpaper program
      mpvpaper # A video wallpaper program for wlroots based wayland compositors.
      swayidle # the idle timeout
      # hypridle # the idle timeout
      swaylock # locking the screen
      # hyprlock # locking the screen
      wlogout # logout menu
      wl-clipboard # copying and pasting
      hyprpicker # color picker
      wshowkeys # Show which key is triggered

      hdrop # a tool to switch windows status (foreground/background)

      pkgs-unstable.hyprshot # screen shot
      grim # taking screenshots
      grimblast # taking screenshots
      slurp # selecting a region to screenshot
      wf-recorder # screen recording

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
    ]
    ++ [
      anyrun
      i3 # gaming
      sway

      # gui
      blueberry
      (mpv.override {scripts = [mpvScripts.mpris];})
      d-spy
      dolphin
      # figma-linux
      kolourpaint
      github-desktop
      gnome.nautilus
      icon-library
      dconf-editor
      qt5.qtimageformats
      vlc
      yad

      # tools
      bat
      eza
      fd
      ripgrep
      fzf
      socat
      jq
      gojq
      acpi
      ffmpeg
      libnotify
      killall
      zip
      unzip
      glib
      foot
      kitty
      starship
      showmethekey
      vscode
      ydotool

      # theming tools
      gradience
      gnome-tweaks

      # hyprland
      brightnessctl
      cliphist
      fuzzel
      grim
      hyprpicker
      tesseract
      imagemagick
      pavucontrol
      playerctl
      swappy
      swaylock-effects
      swayidle
      slurp
      swww
      wayshot
      wlsunset
      wl-clipboard
      wf-recorder

      # langs
      nodePackages.nodejs
      gjs
      bun
      cargo
      go
      gcc
      typescript
      eslint
      # very important stuff
      # uwuify
    ];
}

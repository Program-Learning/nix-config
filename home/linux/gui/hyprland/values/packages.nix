{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    xorg.xhost # to fix sudo graphical application
    brightnessctl # a tool to set screen brightness
    wev # debug which key is pressed
    waybar # the status bar
    swaybg # the wallpaper
    linux-wallpaperengine # A video wallpaper program
    mpvpaper # A video wallpaper program for wlroots based wayland compositors.
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    wl-clipboard # copying and pasting
    hyprpicker # color picker
    wshowkeys # Show which key is triggered

    pkgs-unstable.hyprshot # screen shot
    grim # taking screenshots
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
  ];
}

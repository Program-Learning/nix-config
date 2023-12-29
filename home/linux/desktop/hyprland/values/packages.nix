{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    waybar # the status bar
    swaybg # the wallpaper
    swayidle # the idle timeout
    swaylock # locking the screen
    wlogout # logout menu
    wl-clipboard # copying and pasting
    hyprpicker # color picker
    pkgs-unstable.hyprshot
    wshowkeys # Show which key is triggered

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
}

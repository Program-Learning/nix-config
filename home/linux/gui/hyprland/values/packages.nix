{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xorg.xhost # to fix sudo graphical application
    wev # debug which key is pressed
    libinput # debug input subsystem
    cliphist # Wayland clipboard manager
    waybar # the status bar
    waypaper # GUI wallpaper setter for Wayland-based window managers
    mpvpaper # A video wallpaper program for wlroots based wayland compositors.
    swayidle # the idle timeout
    # hypridle # the idle timeout
    sway-audio-idle-inhibit # audio idle inhibit
    swaylock # locking the screen
    # hyprlock # locking the screen
    wlogout # logout menu
    wshowkeys # Show which key is triggered

    hdrop # a tool to switch windows status (foreground/background)

    grim # taking screenshots
    grimblast # taking screenshots
    slurp # selecting a region to screenshot

    swaybg # the wallpaper
    wl-clipboard # copying and pasting
    hyprpicker # color picker
    brightnessctl

    hyprshot # screen shot
    wf-recorder # screen recording

    # audio
    alsa-utils # provides amixer/alsamixer/...
    kew # terminal music player
    vimpc # A curses mpd client with vi-like key bindings.
    mpd # for playing system sounds
    mpc-cli # command-line mpd client
    ncmpcpp # a mpd client with a UI
    networkmanagerapplet # provide GUI app: nm-connection-editor
  ];
}

{
  mylib,
  config,
  pkgs,
  ...
}:
{
  # wayland related
  home.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";
    # enable native Wayland support for most Electron apps
    "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
    # misc
    "_JAVA_AWT_WM_NONREPARENTING" = "1";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    "QT_QPA_PLATFORM" = "wayland";
    "SDL_VIDEODRIVER" = "wayland";
    "GDK_BACKEND" = "wayland";
    "XDG_SESSION_TYPE" = "wayland";
  };

  home.packages = with pkgs; [
    xorg.xhost # to fix sudo graphical application
    wev # debug which key is pressed
    libinput # debug input subsystem
    cliphist # Wayland clipboard manager
    waybar # the status bar
    waypaper # GUI wallpaper setter for Wayland-based window managers
    mpvpaper # A video wallpaper program for wlroots based wayland compositors.
    # swayidle # the idle timeout
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
    # audio
    alsa-utils # provides amixer/alsamixer/...
    kew # terminal music player
    vimpc # A curses mpd client with vi-like key bindings.
    mpd # for playing system sounds
    mpc # command-line mpd client
    ncmpcpp # a mpd client with a UI
    networkmanagerapplet # provide GUI app: nm-connection-editor
    # screenshot/screencast
    flameshot
    hyprshot # screen shot
    wf-recorder # screen recording
  ];

  # screen locker
  programs.swaylock.enable = true;

  # Logout Menu
  programs.wlogout.enable = true;

  # Scripts
  xdg.configFile."scripts".source =
    mylib.mklinkRelativeToRoot config "home/linux/gui/base/desktop/conf/scripts";
}

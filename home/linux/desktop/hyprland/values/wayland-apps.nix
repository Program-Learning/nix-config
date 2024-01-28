{
  pkgs,
  nur-ryan4yin,
  pkgs-unstable,
  firefox-nightly,
  ...
}: {
  # refer to https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
  xdg.configFile."foot/foot.ini".text =
    ''
      [main]
      dpi-aware=yes
      font=JetBrainsMono Nerd Font:size=13
      shell=${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'
      term=foot
      initial-window-size-pixels=2560x1600
      initial-window-mode=windowed
      pad=0x0                             # optionally append 'center'
      resize-delay-ms=10

      [mouse]
      hide-when-typing=yes
    ''
    + (builtins.readFile "${nur-ryan4yin.packages.${pkgs.system}.catppuccin-foot}/catppuccin-mocha.conf");

  programs = {
    # a wayland only terminal emulator
    foot = {
      enable = true;
      # foot can also be run in a server mode. In this mode, one process hosts multiple windows.
      # All Wayland communication, VT parsing and rendering is done in the server process.
      # New windows are opened by running footclient, which remains running until the terminal window is closed.
      #
      # Advantages to run foot in server mode including reduced memory footprint and startup time.
      # The downside is a performance penalty. If one window is very busy with, for example, producing output,
      # then other windows will suffer. Also, should the server process crash, all windows will be gone.
      server.enable = true;
    };

    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    google-chrome = {
      enable = true;

      commandLineArgs = [
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=4"
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        "--enable-wayland-ime"

        # enable hardware acceleration - vulkan api
        # "--enable-features=Vulkan"
      ];
    };

    firefox = {
      enable = true;
      enableGnomeExtensions = false;
      package = firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin; # firefox with wayland support
    };

    # Fix crash: https://github.com/NixOS/nixpkgs/issues/246509
    # "window.titleBarStyle" = "custom";
    # or `env -u WAYLAND_DISPLAY code`
    vscode = {
      enable = true;
      # use the stable version
      package = pkgs-unstable.vscode.override {
        commandLineArgs = [
          # it seems that my gpu is not supported
          # "--disable-gpu"
          # make it use text-input-v1, which works for kwin 5.27 and weston
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
          # "--ozone-platform=x11"
          # "--force-device-scale-factor=1"
        ];
      };

      # let vscode sync and update its configuration & extensions across devices, using github account.
      # userSettings = {};
    };
  };
}

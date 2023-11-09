{pkgs, pkgs-unstable,...}: {
  # TODO vscode & chrome both have wayland support, but they don't work with fcitx5, need to fix it.
  programs = {
    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    google-chrome = {
      enable = true;

      commandLineArgs = [
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=5"
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
      package = pkgs.firefox-wayland; # firefox with wayland support
    };

    vscode = {
      enable = true;
      # use the stable version
      package = pkgs-unstable.vscode.override {
        commandLineArgs = [
          # it seems that my gpu is not supported
          # "--disable-gpu"
          # make it use text-input-v1, which works for kwin 5.27 and weston
          # "--enable-features=UseOzonePlatform"
          # "--ozone-platform=wayland"
          # "--enable-wayland-ime"
          # "--enable-features=UseOzonePlatform"
          # "--ozone-platform=x11"
        ];
      };

      # let vscode sync and update its configuration & extensions across devices, using github account.
      # userSettings = {};
    };
  };
}

{
  pkgs,
  nur-ryan4yin,
  pkgs-unstable,
  firefox-nightly,
  ...
}: {
  programs = {
    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    google-chrome = {
      enable = true;

      # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=4"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        "--enable-wayland-ime"

        # enable hardware acceleration - vulkan api
        # "--enable-features=Vulkan"
      ];
    };

    vscode = {
      enable = true;
      # let vscode sync and update its configuration & extensions across devices, using github account.
      userSettings = {};
      package =
        (pkgs.vscode.override
          {
            isInsiders = true;
            # https://wiki.archlinux.org/title/Wayland#Electron
            commandLineArgs = [
              "--ozone-platform-hint=auto"
              "--ozone-platform=wayland"
              # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
              # (only supported by chromium/chrome at this time, not electron)
              "--gtk-version=4"
              # make it use text-input-v1, which works for kwin 5.27 and weston
              "--enable-wayland-ime"

              # TODO: fix https://github.com/microsoft/vscode/issues/187436
              # still not works...
              "--password-store=gnome" # use gnome-keyring as password store
            ];
          })
        .overrideAttrs (oldAttrs: rec {
          # Use VSCode Insiders to fix crash: https://github.com/NixOS/nixpkgs/issues/246509
          # Or
          # For vscode normal version now
          # "window.titleBarStyle" = "custom";
          # Or
          # `env -u WAYLAND_DISPLAY code`
          src = builtins.fetchTarball {
            url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
            sha256 = "1diwmkw4yy1pdawqgrjymlpqpjxcgy1h5crf1nm2m4c9dwvswrsa";
          };
          version = "latest";
        });
    };
  };
}
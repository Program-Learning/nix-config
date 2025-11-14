{
  pkgs,
  pkgs-stable,
  browser-previews,
  ...
}:
{
  home.packages = with pkgs; [
    nixpaks.firefox
  ];

  programs = {
    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    google-chrome = {
      enable = true;
      package = if pkgs.stdenv.isAarch64 then pkgs.chromium else pkgs.google-chrome;
      # browser-previews.packages.${pkgs.system}.google-chrome-dev;

      # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        # "--ozone-platform=x11"
        # temporary use x11 for gpu acceleration
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
      userSettings = { };
      package = pkgs.overridden_vscode;
    };
  };
}

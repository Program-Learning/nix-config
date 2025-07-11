# XDG stands for "Cross-Desktop Group", with X used to mean "cross".
# It's a bunch of specifications from freedesktop.org intended to standardize desktops and
# other GUI applications on various systems (primarily Unix-like) to be interoperable:
#   https://www.freedesktop.org/wiki/Specifications/
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
    xdg-user-dirs
    # NOTE: We move this to nixos module for convenience
    # xdg-terminal-exec
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    # manage $XDG_CONFIG_HOME/mimeapps.list
    # xdg search all desktop entries from $XDG_DATA_DIRS, check it by command:
    #  echo $XDG_DATA_DIRS
    # the system-level desktop entries can be list by command:
    #   ls -l /run/current-system/sw/share/applications/
    # the user-level desktop entries can be list by command(user ryan):
    #  ls /etc/profiles/per-user/ryan/share/applications/
    mimeApps = {
      enable = true;
      associations.added = let
        browser = ["google-chrome-unstable.desktop" "google-chrome.desktop" "firefox.desktop"];
        editor = ["dev.zed.Zed.desktop" "nvim.desktop" "code-insiders.desktop" "code.desktop" "Helix.desktop"];
        picture = ["imv-dir.desktop"];
        video = ["mpv.desktop"];
        audio = ["mpv.desktop"];
        office = ["onlyoffice-desktopeditors.desktop" "writer.desktop"];
        code = ["dev.zed.Zed.desktop" "nvim.desktop" "code-insiders.desktop" "code.desktop" "Helix.desktop"];
        file-manager = ["org.gnome.Nautilus.desktop"];
      in {
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = office;
        "application/wps-office.docx" = office;
        "application/x-php" = code;
        "text/plain" = editor;
        "text/x-makefile" = editor;
        "application/x-wine-extension-ini" = editor;
      };
      # let `xdg-open` to open the url with the correct application.
      defaultApplications = let
        browser = ["google-chrome-unstable.desktop" "google-chrome.desktop" "firefox.desktop"];
        editor = ["dev.zed.Zed.desktop" "nvim.desktop" "code-insiders.desktop" "code.desktop" "Helix.desktop"];
        picture = ["imv-dir.desktop"];
        video = ["mpv.desktop"];
        audio = ["mpv.desktop"];
        office = ["onlyoffice-desktopeditors.desktop" "writer.desktop"];
        code = ["dev.zed.Zed.desktop" "nvim.desktop" "code-insiders.desktop" "code.desktop" "Helix.desktop"];
        file-manager = ["org.gnome.Nautilus.desktop"];
      in {
        "application/json" = browser;
        "application/pdf" = browser; # TODO: pdf viewer

        "text/html" = browser;
        "text/xml" = browser;
        "text/plain" = editor;
        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-shellscript" = editor;
        "application/x-php" = code;
        "application/x-wine-extension-ini" = editor;

        # define default applications for some url schemes.
        "x-scheme-handler/about" = browser; # open `about:` url with `browser`
        "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        # https://github.com/microsoft/vscode/issues/146408
        "x-scheme-handler/vscode" = ["code-url-handler.desktop"]; # open `vscode://` url with `code-url-handler.desktop`
        "x-scheme-handler/vscode-insiders" = ["code-insiders-url-handler.desktop"]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`
        "x-scheme-handler/zoommtg" = ["Zoom.desktop"];

        # all other unknown schemes will be opened by this default application.
        # "x-scheme-handler/unknown" = editor;

        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop "];

        "audio/*" = audio;
        "video/*" = video;
        "image/*" = picture;
        "image/gif" = picture;
        "image/jpeg" = picture;
        "image/png" = picture;
        "image/webp" = picture;
        "image/bmp" = picture;
        "image/tiff" = picture;
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = office;
        "application/wps-office.docx" = office;

        "inode/directory" = file-manager;
      };

      associations.removed = {
        # ......
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}

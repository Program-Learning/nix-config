{config, pkgs, ...}: let
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in rec {
  home.packages = with pkgs; [
    neofetch
    nnn          # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep  # recursively searches directories for a regex pattern
    jq       # A lightweight and flexible command-line JSON processor
    yq-go    # yaml processer https://github.com/mikefarah/yq
    exa # A modern replacement for ‘ls’

    # networking tools
    mtr   # A network diagnostic tool
    iperf3
    nmap
    socat
    ldns  # replacement of dig, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    p7zip
    xz
    zstd

    # productivity
    hugo
  ];

  programs = {
    # A terminal multiplexer
    tmux = {
      enable = true;
    };

    # a cat(1) clone with syntax highlighting and Git integration.
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "Catppuccin-mocha";
      };
      themes = {
        Catppuccin-mocha = builtins.readFile (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme";
          hash = "sha256-qMQNJGZImmjrqzy7IiEkY5IhvPAMZpq0W6skLLsng/w=";
        });
      };
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  services = {
    # syncthing.enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };

  # add environment variables
  systemd.user.sessionVariables = {
    # clean up ~
    LESSHISTFILE = cache + "/less/history";
    LESSKEY = c + "/less/lesskey";
    WINEPREFIX = d + "/wine";

    # set this variable make i3 failed to start
    # related issue:
    #   https://github.com/sddm/sddm/issues/871
    # XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

    # set default applications
    BROWSER = "firefox";
    TERMINAL = "alacritty";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  home.sessionVariables = systemd.user.sessionVariables;

  home.shellAliases = {
    k = "kubectl";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
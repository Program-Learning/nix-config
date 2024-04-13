let
  shellAliases = {
    k = "kubectl";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
in {
  # only works in bash/zsh, not nushell
  home.shellAliases = shellAliases;

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    inherit shellAliases;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
      export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/'
      export QT_QPA_PLATFORM=xcb
      export TLDR_AUTO_UPDATE_DISABLED=1
    '';
  };
}

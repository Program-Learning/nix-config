{
  pkgs,
  pkgs-latest,
  wpsFonts,
  ...
}:
{
  # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
  fonts = {
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    fontDir.enable = true;

    # fonts are defined in /modules/base/fonts.nix, used by both NixOS & Darwin.
    # packages = [ ... ];

    fontconfig = {
      # User defined default fonts
      # https://catcat.cc/post/2021-03-07/
      defaultFonts = rec {
        serif = [
          # 西文: 衬线字体（笔画末端有修饰(衬线)的字体，通常用于印刷。）
          "Source Sans 3"
          # 中文: 宋体（港台称明體）
          "Source Han Serif SC" # 思源宋体
          "Source Han Serif TC"
        ];
        # SansSerif 也简写做 Sans, Sans 在法语中就是「without」或者「无」的意思
        sansSerif = [
          # 西文: 无衬线字体（指笔画末端没有修饰(衬线)的字体，通常用于屏幕显示）
          "Source Serif 4"
          # 中文: 黑体
          "LXGW WenKai Screen" # 霞鹜文楷 屏幕阅读版
          "Source Han Sans SC" # 思源黑体
          "Source Han Sans TC"
        ];
        # 等宽字体
        monospace = [
          # 中文
          "Maple Mono NF CN" # 中英文宽度完美 2:1 的字体
          "Source Han Mono SC" # 思源等宽
          "Source Han Mono TC"
          # 西文
          "JetBrainsMono Nerd Font"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Emoji"
          "Symbols Nerd Font"
          "Twemoji"
        ];
      };
      antialias = true; # 抗锯齿
      hinting.enable = false; # 禁止字体微调 - 高分辨率下没这必要
      subpixel = {
        rgba = "rgb"; # IPS 屏幕使用 rgb 排列
      };
      # localConf = ''
      #   <?xml version="1.0"?>
      #   <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      #   <fontconfig>

      #   <!-- Default system-ui fonts -->
      #   <match target="pattern">
      #     <test name="family">
      #       <string>system-ui</string>
      #     </test>
      #     <edit name="family" mode="prepend" binding="strong">
      #       <string>sans-serif</string>
      #     </edit>
      #   </match>

      #   <!-- Default sans-serif fonts-->
      #   <match target="pattern">
      #     <test name="family">
      #       <string>sans-serif</string>
      #     </test>
      #     <edit name="family" mode="prepend" binding="strong">
      #       <string>Noto Sans CJK SC</string>
      #       <string>Noto Sans</string>
      #       <string>Twemoji</string>
      #     </edit>
      #   </match>

      #   <!-- Default serif fonts-->
      #   <match target="pattern">
      #     <test name="family">
      #       <string>serif</string>
      #     </test>
      #     <edit name="family" mode="prepend" binding="strong">
      #       <string>Noto Serif CJK SC</string>
      #       <string>Noto Serif</string>
      #       <string>Twemoji</string>
      #     </edit>
      #   </match>

      #   <!-- Default monospace fonts-->
      #   <match target="pattern">
      #     <test name="family">
      #       <string>monospace</string>
      #     </test>
      #     <edit name="family" mode="prepend" binding="strong">
      #       <string>Noto Sans Mono CJK SC</string>
      #       <string>Symbols Nerd Font</string>
      #       <string>Twemoji</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="prgname" compare="not_eq">
      #       <string>chrome</string>
      #     </test>
      #     <test name="family" compare="contains">
      #       <string>Noto Sans Mono CJK</string>
      #     </test>
      #     <edit name="family" mode="prepend" binding="strong">
      #       <string>Iosevka Term</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>zh-HK</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans CJK HK</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>zh-HK</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Serif CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <!-- not have HK -->
      #       <string>Noto Serif CJK TC</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>zh-HK</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans Mono CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans Mono CJK HK</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>zh-TW</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans CJK TC</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>zh-TW</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Serif CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Serif CJK TC</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>zh-TW</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans Mono CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans Mono CJK TC</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>ja</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans CJK JP</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>ja</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Serif CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Serif CJK JP</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>ja</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans Mono CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans Mono CJK JP</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>ko</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans CJK KR</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>ko</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Serif CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Serif CJK KR</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang">
      #       <string>ko</string>
      #     </test>
      #     <test name="family">
      #       <string>Noto Sans Mono CJK SC</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Noto Sans Mono CJK KR</string>
      #     </edit>
      #   </match>

      #   <!-- Replace monospace fonts -->
      #   <match target="pattern">
      #     <test name="family" compare="contains">
      #       <string>Source Code</string>
      #     </test>
      #     <edit name="family" binding="strong">
      #       <string>Iosevka Term</string>
      #     </edit>
      #   </match>
      #     <match target="pattern">
      #     <test name="lang" compare="contains">
      #       <string>en</string>
      #     </test>
      #     <test name="family" compare="contains">
      #       <string>Noto Sans CJK</string>
      #     </test>
      #     <edit name="family" mode="prepend" binding="strong">
      #       <string>Noto Sans</string>
      #     </edit>
      #   </match>

      #   <match target="pattern">
      #     <test name="lang" compare="contains">
      #       <string>en</string>
      #     </test>
      #     <test name="family" compare="contains">
      #       <string>Noto Serif CJK</string>
      #     </test>
      #     <edit name="family" mode="prepend" binding="strong">
      #       <string>Noto Serif</string>
      #     </edit>
      #   </match>

      #   </fontconfig>
      # '';
    };
  };

  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = true;
    fonts = with pkgs; [
      {
        name = "Maple Mono NF CN";
        package = maple-mono.NF-CN-unhinted;
      }
      {
        name = "JetBrainsMono Nerd Font";
        package = nerd-fonts.jetbrains-mono;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=14";
    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
}

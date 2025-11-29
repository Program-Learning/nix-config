{
  lib,
  pkgs,
  pkgs-stable,
  nur-ryan4yin,
  nur-DataEraserC,
  blender-bin,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # creative
      # gimp      # image editing, I prefer using figma in browser instead of this one
      (gimp-with-plugins.override {
        plugins = with gimpPlugins; [
          # fourier
          # resynthesizer # broken since 2023-03-20
          # gmic
          # bimp
        ];
      })
      # inkscape # vector graphics
      # krita # digital painting
      # musescore # music notation
      # reaper # audio production
      # sonic-pi # music programming

      # 2d game design
      # aseprite # Animated sprite editor & pixel art tool

      # this app consumes a lot of storage, so do not install it currently
      # kicad     # 3d printing, electrical engineering
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      # https://github.com/edolstra/nix-warez/blob/master/blender/flake.nix
      blender-bin.packages.${pkgs.stdenv.hostPlatform.system}.blender_4_2 # 3d modeling

      ldtk # A modern, versatile 2D level editor

      # fpga
      # python313Packages.apycula # gowin fpga
      # yosys # fpga synthesis
      # nextpnr # fpga place and route
      # openfpgaloader # fpga programming
      # nur-ryan4yin.packages.${pkgs.stdenv.hostPlatform.system}.gowin-eda-edu-ide # app: `gowin-env` => `gw_ide` / `gw_pack` / ...

      # Mayuri

      # wechat dev tool
      # nur-DataEraserC.packages.${pkgs.system}.wechat_dev_tools_appimage
      nur-DataEraserC.packages.${pkgs.system}.wechat_dev_tools_bin

      # Adobe software appimage
      # nur-DataEraserC.packages.${pkgs.system}.Adobe_Photoshop_CS6_appimage
      # nur-DataEraserC.packages.${pkgs.system}.Adobe_Illustrator_CS6_appimage

      # kicad # 3d printing, electrical engineering
      # ngspice # electrical engineering
      # digital # A digital logic designer and circuit simulator.
      # logisim-evolution # Digital logic designer and simulator
    ]);

  programs = {
    # live streaming
    obs-studio = {
      enable = pkgs.stdenv.isx86_64;
      plugins = with pkgs.obs-studio-plugins; [
        # screen capture
        wlrobs
        # obs-ndi
        # obs-nvfbc
        obs-teleport
        # obs-hyperion
        droidcam-obs
        obs-vkcapture
        obs-gstreamer
        input-overlay
        obs-multi-rtmp
        obs-source-clone
        obs-shaderfilter
        obs-source-record
        obs-livesplit-one
        looking-glass-obs
        obs-vintage-filter
        obs-command-source
        obs-move-transition
        obs-backgroundremoval
        # advanced-scene-switcher
        obs-pipewire-audio-capture
        obs-vaapi
        obs-3d-effect
      ];
    };
  };
}

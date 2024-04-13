{
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  nur-ryan4yin,
  nur-program-learning,
  ...
}: {
  home.packages = with pkgs; [
    # creative
    pkgs-stable.blender # 3d modeling
    # gimp      # image editing, I prefer using figma in browser instead of this one
    (gimp-with-plugins.override {
      plugins = with gimpPlugins; [
        fourier
        # resynthesizer # broken since 2023-03-20
        gmic
        bimp
      ];
    })
    shotcut # video editor
    inkscape # vector graphics
    krita # digital painting
    pkgs-stable.musescore # music notation
    # reaper # audio production
    # sonic-pi # music programming

    # this app consumes a lot of storage, so do not install it currently
    pkgs-stable.kicad # 3d printing, eletrical engineering
    # kicad-unstable # 3d printing, eletrical engineering
    ngspice # eletrical engineering
    digital # A digital logic designer and circuit simulator.
    logisim-evolution # Digital logic designer and simulator

    freecad # A CAD software

    # fpga
    pkgs-unstable.python311Packages.apycula # gowin fpga
    pkgs-unstable.yosys # fpga synthesis
    pkgs-unstable.nextpnr # fpga place and route
    pkgs-unstable.openfpgaloader # fpga programming
    nur-ryan4yin.packages.${pkgs.system}.gowin-eda-edu-ide # app: `gowin-env` => `gw_ide` / `gw_pack` / ...
    # nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_appimage
    nur-program-learning.packages.${pkgs.system}.wechat_dev_tools_bin
    # nur-program-learning.packages.${pkgs.system}.Adobe_Photoshop_CS6_appimage
    # nur-program-learning.packages.${pkgs.system}.Adobe_Illustrator_CS6_appimage
  ];

  programs = {
    # live streaming
    obs-studio = {
      enable = true;
      plugins = with pkgs-stable.obs-studio-plugins; [
        # screen capture
        wlrobs
        # obs-ndi
        obs-vaapi
        obs-nvfbc
        obs-teleport
        # obs-hyperion
        droidcam-obs
        obs-vkcapture
        obs-gstreamer
        obs-3d-effect
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
        advanced-scene-switcher
        obs-pipewire-audio-capture
      ];
    };
  };
}

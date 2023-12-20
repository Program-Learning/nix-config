{
  pkgs,
  pkgs-unstable,
  nur-ryan4yin,
  nur-program-learning,
  ...
}: {
  home.packages = with pkgs; [
    # creative
    blender # 3d modeling
    # gimp      # image editing, I prefer using figma in browser instead of this one
    (gimp-with-plugins.override {
      plugins = with gimpPlugins; [
        fourier
        # resynthesizer # broken since 2023-03-20
        gmic
      ];
    })
    shotcut
    inkscape # vector graphics
    krita # digital painting
    musescore # music notation
    # reaper # audio production
    pkgs-unstable.sonic-pi # music programming

    # this app consumes a lot of storage, so do not install it currently
    kicad-unstable     # 3d printing, eletrical engineering
    ngspice
    digital # A digital logic designer and circuit simulator.
    logisim-evolution # Digital logic designer and simulator

    freecad

    # fpga
    pkgs-unstable.python311Packages.apycula # gowin fpga
    pkgs-unstable.yosys # fpga synthesis
    pkgs-unstable.nextpnr # fpga place and route
    pkgs-unstable.openfpgaloader # fpga programming
    nur-ryan4yin.packages.${pkgs.system}.gowin-eda-edu-ide # app: `gowin-env` => `gw_ide` / `gw_pack` / ...
    nur-program-learning.packages.${pkgs.system}.Adobe_Photoshop_CS6_appimage
    nur-program-learning.packages.${pkgs.system}.Adobe_Illustrator_CS6_appimage
  ];

  programs = {
    # live streaming
    obs-studio = {
      enable = true;
      plugins = with pkgs; [
        # screen capture
        obs-studio-plugins.wlrobs
        # obs-studio-plugins.obs-ndi
        obs-studio-plugins.obs-vaapi
        obs-studio-plugins.obs-nvfbc
        obs-studio-plugins.obs-teleport
        # obs-studio-plugins.obs-hyperion
        obs-studio-plugins.droidcam-obs
        obs-studio-plugins.obs-vkcapture
        obs-studio-plugins.obs-gstreamer
        obs-studio-plugins.obs-3d-effect
        obs-studio-plugins.input-overlay
        obs-studio-plugins.obs-multi-rtmp
        obs-studio-plugins.obs-source-clone
        obs-studio-plugins.obs-shaderfilter
        obs-studio-plugins.obs-source-record
        obs-studio-plugins.obs-livesplit-one
        obs-studio-plugins.looking-glass-obs
        obs-studio-plugins.obs-vintage-filter
        obs-studio-plugins.obs-command-source
        obs-studio-plugins.obs-move-transition
        obs-studio-plugins.obs-backgroundremoval
        obs-studio-plugins.advanced-scene-switcher
        obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
  };
}

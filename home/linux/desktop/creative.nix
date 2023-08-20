{pkgs, ...}: {
  home.packages = with pkgs; [
    # creative
    # blender   # 3d modeling
    # gimp      # image editing, I prefer using figma in browser instead of this one
    inkscape # vector graphics
    krita # digital painting
    musescore # music notation
    reaper # audio production

    # this app consumes a lot of storage, so do not install it currently
    # kicad     # 3d printing, eletrical engineering
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

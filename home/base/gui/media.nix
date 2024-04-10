{
  pkgs,
  config,
  pkgs-unstable,
  ...
}:
# processing audio/video
{
  home.packages = with pkgs; [
    ffmpeg

    # images
    viu # Terminal image viewer with native support for iTerm and Kitty
    imagemagick
    graphviz
  ];
}

{
  pkgs,
  config,
  pkgs-unstable,
  ...
}:
# processing audio/video
{
  home.packages = (with pkgs; [
    (ffmpeg-full.override { withV4l2 = true; withV4l2M2m = true;})

    # images
    viu # Terminal image viewer with native support for iTerm and Kitty
    imagemagick
    graphviz
  ])
  ++
  (with pkgs-unstable; [
    ]);
}

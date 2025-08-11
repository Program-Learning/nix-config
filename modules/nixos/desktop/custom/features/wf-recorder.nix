# https://github.com/colescott/dotfiles/blob/1d85d3e3e4bb8e49b095d19da9ce318d21826794/features/wf-recorder.nix
# usage features.wf-recorder.enable = true;
# remember to import me!
{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.wf-recorder;

  wf-screenshare = pkgs.writeScriptBin "wf-screenshare" ''
    #!${pkgs.bash}/bin/bash
    #set -euxo pipefail
    set -e -o pipefail
    pkill -x wf-screenshare-region

    [ $? -ne 0 ] && {
        notify-send -t 2000 'Screen sharing' 'Select an area to start the recording...'
        geometry="$(${pkgs.slurp}/bin/slurp)"
        { sleep 1 && pkill -RTMIN+3 -x waybar; } &
        if wf-screenshare-region "$geometry" || [ $? -eq 143 ]; then
          true
        fi
        pkill -RTMIN+3 -x waybar
        notify-send 'Screen sharing' 'Recording is complete'
    }
  '';
  wf-screenshare-region = pkgs.writeScriptBin "wf-screenshare-region" ''
    #!${pkgs.bash}/bin/bash
    set -e -o pipefail

    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <dimensions>"
        exit 1
    fi

    dimensions=$1
    ${pkgs.wf-recorder}/bin/wf-recorder --audio --muxer=v4l2 --codec=rawvideo --pixel-format=yuv420p --file=/dev/video9 --geometry=$dimensions
  '';
in
{
  options.features.wf-recorder = {
    enable = mkEnableOption "Enable wf-recorder screensharing module";
  };

  config = mkIf cfg.enable {
    # Extra kernel modules
    boot.extraModulePackages = [
      # config.boot.kernelPackages.v4l2loopback.out
      config.boot.kernelPackages.v4l2loopback
    ];

    # Register a v4l2loopback device at boot
    boot.kernelModules = [
      # Virtual Camera
      "v4l2loopback"
      # Virtual Microphone, built-in
      "snd-aloop"
    ];

    boot.extraModprobeConfig = ''
      # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
      # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
      # https://github.com/umlaeute/v4l2loopback
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="Virtual Camera"
    '';

    environment.systemPackages = [
      wf-screenshare
      wf-screenshare-region
    ];
  };
}

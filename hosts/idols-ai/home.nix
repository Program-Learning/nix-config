{ config, niri, ... }:
{
  programs.ssh.matchBlocks."github.com".identityFile = "${config.home.homeDirectory}/.ssh/y9000k2021h_id_ed25519";

  modules.desktop.nvidia.enable = true;

  modules.desktop.hyprland.settings.source = [
    "${config.home.homeDirectory}/nix-config/hosts/idols-ai/hypr-hardware.conf"
  ];

  modules.desktop.niri = {
    settings =
      let
        inherit (niri.lib.kdl)
          node
          plain
          leaf
          flag
          ;
      in
      [
        # running `niri msg outputs` to find outputs
        (node "output" "eDP-1" [
          # Uncomment this line to disable this output.
          # (flag "off")

          # Scale is a floating-point number, but at the moment only integer values work.
          (leaf "scale" 1.5)

          # Transform allows to rotate the output counter-clockwise, valid values are:
          # normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
          (leaf "transform" "normal")

          # Resolution and, optionally, refresh rate of the output.
          # The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
          # If the refresh rate is omitted, niri will pick the highest refresh rate
          # for the resolution.
          # If the mode is omitted altogether or is invalid, niri will pick one automatically.
          # Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
          (leaf "mode" "2560x1600@240")

          # Position of the output in the global coordinate space.
          # This affects directional monitor actions like "focus-monitor-left", and cursor movement.
          # The cursor can only move between directly adjacent outputs.
          # Output scale has to be taken into account for positioning:
          # outputs are sized in logical, or scaled, pixels.
          # For example, a 3840×2160 output with scale 2.0 will have a logical size of 1920×1080,
          # so to put another output directly adjacent to it on the right, set its x to 1920.
          # It the position is unset or results in an overlap, the output is instead placed
          # automatically.
          (leaf "position" {
            x = 0;
            y = 0;
          })
        ])
        # (node "output" "HDMI-A-1" [
        #   (leaf "scale" 1.5)
        #   (leaf "transform" "normal")
        #   (leaf "mode" "3840x2160@60")
        #   (leaf "position" {
        #     x = 2560; # on the right of DP-2
        #     y = 0;
        #   })
        # ])

        # ============= Named Workspaces =============
        # (node "workspace" "2browser" [ (leaf "open-on-output" "DP-2") ])
        # (node "workspace" "4gaming" [ (leaf "open-on-output" "DP-2") ])
        # (node "workspace" "5music" [ (leaf "open-on-output" "DP-2") ])

        # (node "workspace" "1terminal" [ (leaf "open-on-output" "HDMI-A-1") ])
        # (node "workspace" "3chat" [ (leaf "open-on-output" "HDMI-A-1") ])
        # (node "workspace" "6file" [ (leaf "open-on-output" "HDMI-A-1") ])
        # (node "workspace" "0other" [ (leaf "open-on-output" "HDMI-A-1") ])
      ];
  };
}

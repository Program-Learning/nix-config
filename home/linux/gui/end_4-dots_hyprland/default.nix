{
  pkgs,
  config,
  lib,
  anyrun,
  ags,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.end_4-dots_hyprland-hm_module;
in {
  imports = [
    ags.homeManagerModules.default
    # anyrun.homeManagerModules.default
    ./options
  ];

  options.modules.desktop.end_4-dots_hyprland-hm_module = {
    enable = mkEnableOption "hyprland compositor";
    settings = lib.mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Hyprland configuration value";
          };
      in
        valueType;
      default = {};
    };
  };

  config = mkIf cfg.enable (
    mkMerge ([
        {
          wayland.windowManager.hyprland.settings = cfg.settings;
        }
      ]
      ++ (import ./values args))
  );
}

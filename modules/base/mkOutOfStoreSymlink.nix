{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.mkOutOfStoreSymlink;
in {
  options = {
    modules.mkOutOfStoreSymlink = {
      enable = mkOption {
        default = true;
        type = lib.types.bool;
        description = lib.mdDoc "use mkOutOfStoreSymlink instead for link file can make file writable";
      };
      configPath = mkOption {
        type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
        default = "";
        description = lib.mdDoc "where the nix-config is located. required when `enable == true`";
      };
    };
  };
  config = {
    assertions = [
      {
        assertion = cfg.enable && cfg.configPath != "" && cfg.configPath != null;
        message = "configPath is required when `modules.mkOutOfStoreSymlink.enable == true`";
      }
    ];
  };
}

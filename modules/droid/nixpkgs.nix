{
  config,
  pkgs,
  myvars,
  nuenv,
  nur-xddxdd,
  nur-DataEraserC,
  ...
} @ args: {
  nixpkgs.overlays =
    [
    ]
    ++ (import ../../overlays (args
      // {
        # tell overlays to use the nix-on-droid specific overlay
        feat."nix-on-droid" = true;
      }));
}

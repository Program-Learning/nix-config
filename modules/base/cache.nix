{
  nur-xddxdd,
  nur-DataEraserC,
  ...
}:
{
  imports = [
    # nur-xddxdd.nixosModules.setupOverlay
    nur-xddxdd.nixosModules.nix-cache-garnix
    nur-xddxdd.nixosModules.nix-cache-attic

    # nur-DataEraserC.nixosModules.setupOverlay
    nur-DataEraserC.nixosModules.nix-cache-cachix
  ];
}

{pkgs, ...}: {
  # FHS environment, flatpak, appImage, etc.
  environment.systemPackages = [
    # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSUserEnv (base
          // {
            name = "fhs";
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = ["dev"];
          })
    )

    # A tool to run appimage directly
    pkgs.appimage-run
  ];

  # https://flatpak.org/setup/NixOS
  services.flatpak.enable = true;
}

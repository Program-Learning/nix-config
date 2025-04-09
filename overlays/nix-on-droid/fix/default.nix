_: (
  _: super: let
    disabled_packages = [
      "python311.withPackages.jupyter"
      "python311.withPackages.jupyterlab"
      "python311.withPackages.pyclip"
      "nodePackages.typescript-language-server"
      "flutter"
    ];

    disabled_packages_map = builtins.listToAttrs (map (pkg: {
        name = pkg;
        value = super.emptyDirectory;
      })
      disabled_packages);
  in
    disabled_packages_map
)

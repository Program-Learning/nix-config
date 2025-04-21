_: (
  _: super: let
    disabled_packages = [
      "python313Packages.jupyter"
      "python313Packages.jupyterlab"
      "python313Packages.pyclip"
      "nodePackages.typescript-language-server"
      "flutter"
      "nickel"
    ];

    disabled_packages_map = builtins.listToAttrs (map (pkg: {
        name = pkg;
        value = super.emptyDirectory;
      })
      disabled_packages);
  in
    disabled_packages_map
)

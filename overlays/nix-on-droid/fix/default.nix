_: (
  _: super: let
    disabled_packages = [
      "python311Packages.jupyter"
      "python311Packages.jupyterlab"
      "python311Packages.pyclip"
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

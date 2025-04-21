_: final: prev: let
  disabled_packages = [
    "jupyter"
    "jupyterlab"
    "pyclip"
  ];
  disabled_packages_map = builtins.listToAttrs (map (pkg: {
      name = pkg;
      value = prev.emptyDirectory;
    })
    disabled_packages);
in {
  pythonPackagesOverlays =
    (prev.pythonPackagesOverlays or [])
    ++ [
      (python-final: python-prev: disabled_packages_map)
    ];

  python311 = let
    self = prev.python311.override {
      inherit self;
      packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
    };
  in
    self;

  python311Packages = final.python311.pkgs;
}

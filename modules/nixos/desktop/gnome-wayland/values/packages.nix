{
  pkgs,
  pkgs-unstable,
  ...
}: {
  environment.gnome.excludePackages =
    (with pkgs; [
      ])
    ++ (with pkgs.gnome; [
      ]);
}

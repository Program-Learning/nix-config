{
  pkgs,
  ...
}:
{
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
    ]);
}

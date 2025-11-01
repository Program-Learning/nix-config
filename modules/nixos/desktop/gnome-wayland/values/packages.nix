{
  pkgs,
  ...
}:
{
  environment.gnome.excludePackages =
    (with pkgs; [
    ])
    ++ (with pkgs.gnome; [
    ]);
}

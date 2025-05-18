{
  config,
  mylib,
  ...
}: {
  home.file.".aerospace.toml".source = mylib.mklinkRelativeToRoot config "home/darwin/aerospace/aerospace.toml";
}

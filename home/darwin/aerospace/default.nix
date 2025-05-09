{
  config,
  mylib,
  ...
}: {
  home.file.".aerospace.toml".source = mylib.mklink config "home/darwin/aerospace/aerospace.toml";
}

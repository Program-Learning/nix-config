{
  pkgs,
  pkgs-unstable,
  nixified-ai,
  ...
}: {
  home.packages = with nixified-ai; [
    invokeai-nvidia
    textgen-nvidia
  ];
}

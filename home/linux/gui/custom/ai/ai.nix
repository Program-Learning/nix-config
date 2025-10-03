{
  pkgs,
  pkgs-unstable,
  nixified-ai,
  nixified-ai-old,
  ...
}:
{
  home.packages = [
    nixified-ai.packages.${pkgs.system}.comfyui-nvidia
    nixified-ai-old.packages.${pkgs.system}.invokeai-nvidia
    # nixified-ai-old.packages.${pkgs.system}.textgen-nvidia
  ];
}

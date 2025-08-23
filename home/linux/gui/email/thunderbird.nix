{ ... }:
{
  programs.thunderbird = {
    profiles = {
      default = {
        # name = "default";
        isDefault = true;
      };
    };
    enable = true;
  };
}

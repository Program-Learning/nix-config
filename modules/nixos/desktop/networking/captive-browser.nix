{ config, ... }:
{
  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp4s0";
}

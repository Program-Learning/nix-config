{
  pkgs,
  mylib,
  pkgs-stable,
  ...
}:
{
  imports = mylib.scanPaths ./.;

  environment.systemPackages = with pkgs; [
    wayvnc # vnc server
    wprs
    novnc # vnc client
    # parsec-bin
    waypipe
    moonlight-qt # moonlight client, for streaming games/desktop from a PC
  ];
}

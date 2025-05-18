{
  pkgs,
  mylib,
  pkgs-stable,
  ...
}: {
  imports = mylib.scanPaths ./.;

  environment.systemPackages = with pkgs; [
    wayvnc # vnc server
    waypipe
    wprs
    moonlight-qt # moonlight client, for streaming games/desktop from a PC
    pkgs-stable.rustdesk # p2p remote desktop
    novnc # vnc client
    # parsec-bin
  ];
}

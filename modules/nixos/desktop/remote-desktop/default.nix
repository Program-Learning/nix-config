{
  pkgs,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  environment.systemPackages = with pkgs; [
    wayvnc # vnc server
    waypipe
    moonlight-qt # moonlight client, for streaming games/desktop from a PC
    novnc # vnc client
    # parsec-bin
    rustdesk # p2p remote desktop
  ];
}

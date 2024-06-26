{
  pkgs,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  environment.systemPackages = with pkgs; [
    wayvnc
    waypipe
    moonlight-qt # moonlight client, for streaming games/desktop from a PC
    novnc
    # parsec-bin
    rustdesk # p2p remote desktop
  ];
}

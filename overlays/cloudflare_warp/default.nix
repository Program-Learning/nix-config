_: (_: super: {
  cloudflare-warp = super.cloudflare-warp.overrideAttrs (oldAttrs @ {postInstall ? "", ...}: let
    new_postInstall = ''
      #${postInstall}
      wrapProgram $out/bin/warp-svc --prefix PATH : ${super.lib.makeBinPath [super.nftables super.lsof]}
      #sed -i "s@^CapabilityBoundingSet=.*@CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW CAP_NET_ADMIN CAP_DAC_OVERRIDE@g" $out/lib/systemd/system/warp-svc.service
      #sed -i "s@^AmbientCapabilities=.*@AmbientCapabilities=CAP_NET_BIND_SERVICE CAP_NET_RAW CAP_NET_ADMIN CAP_DAC_OVERRIDE@g" $out/lib/systemd/system/warp-svc.service
    '';
  in {
    postInstall = new_postInstall;
  });
})

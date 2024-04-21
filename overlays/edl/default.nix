_: (_: super: {
  edl = super.edl.overrideAttrs (oldAttrs @ {postInstall ? "", ...}: let
    new_postInstall = ''
      ${postInstall}
      rm $out/LICENSE
    '';
  in {
    postInstall = new_postInstall;
  });
})

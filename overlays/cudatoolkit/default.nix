_: (_: super: {
  cudatoolkit = super.cudatoolkit.overrideAttrs (oldAttrs @ {postInstall ? "", ...}: let
    new_postInstall = ''
      ${postInstall}
      rm $out/LICENSE
    '';
  in {
    postInstall = new_postInstall;
  });
})

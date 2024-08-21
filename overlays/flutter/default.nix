_: (_: super: {
  flutter = super.flutter.overrideAttrs (oldAttrs @ {postInstall ? "", ...}: let
    new_postInstall = ''
      ${postInstall}
      rm $out/LICENSE
      rm $out/README.md
      rm $out/version
    '';
  in {
    postInstall = new_postInstall;
  });
})

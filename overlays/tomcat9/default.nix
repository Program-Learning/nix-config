_: (_: super: {
  tomcat9 = super.tomcat9.overrideAttrs (oldAttrs @ {
    installPhase ? "",
    postInstall ? "",
    ...
  }: let
    new_installPhase = ''
      runHook preInstall
      ${installPhase}
      runHook postInstall

    '';
    new_postInstall = ''
      ${postInstall}
      rm $out/CONTRIBUTING.md
      rm $out/BUILDING.txt
      rm $out/LICENSE
      rm $out/README.md
    '';
  in {
    postInstall = new_postInstall;
    installPhase = new_installPhase;
  });
})

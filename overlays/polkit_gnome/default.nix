_: (_: super: {
  polkit_gnome_exported = super.polkit_gnome.overrideAttrs (oldAttrs @ {postInstall ? "", ...}: let
    new_postInstall = ''
      ${postInstall}
      mkdir $out/bin
      ln -s $out/libexec/polkit-gnome-authentication-agent-1 $out/bin
    '';
  in {
    postInstall = new_postInstall;
  });
})

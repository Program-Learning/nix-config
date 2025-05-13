{
  stdenvNoCC,
  polkit_gnome,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (polkit_gnome) meta version;
  pname = polkit_gnome.pname + "_exported";

  nativeBuildInputs = [];

  dontUnpack = true;

  postInstall = ''
    source ${../utils/link_file_in_source_dir_to_target_dir_rec.bash}

    mkdir -p $out

    link_file_in_source_dir_to_target_dir_rec "${polkit_gnome}" "$out"

    mkdir -p $out/bin

    ln -sfn $out/libexec/polkit-gnome-authentication-agent-1 $out/bin/
  '';
}

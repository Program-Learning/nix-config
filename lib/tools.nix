# Source: https://github.com/jas0nt/nix-config/blob/825733cb88e4a94cf1ea1dce6b257c86ecc08ae3/tools.nix
{
  substitute-file =
    file:
    let
      const = import ./const.nix;
      keys = builtins.attrNames const;
      patterns = map (k: "@${k}@") keys;
      replacements = map (k: const.${k}) keys;
    in
    builtins.replaceStrings patterns replacements (builtins.readFile file);

  scale =
    pkgs: pkg: factor:
    pkgs.symlinkJoin {
      name = "${pkg.name}-scaled";
      paths = [ pkg ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        for f in $out/bin/*; do
          wrapProgram $f \
            --set QT_SCALE_FACTOR "${toString factor}" \
            --set GDK_DPI_SCALE "${toString factor}"
        done
      '';
    };
}

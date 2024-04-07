_: (_: super: {
  lenovo-legion = super.lenovo-legion.overrideAttrs (oldAttrs @ {
    postInstall ? "",
    postPatch,
    lib,
    ...
  }: let
    new_postInstall = ''
      ${postInstall}
      cp $out/share/applications/legion_gui.desktop $out/share/applications/legion_gui_with_cap.desktop
      sed -i "s@^Exec=pkexec legion_gui@Exec=legion_gui_with_cap@g" $out/share/applications/legion_gui_with_cap.desktop
      sed -i "s@^Name=Root LenovoLegionLinux@Name=LenovoLegionLinux with capability@g" $out/share/applications/legion_gui_with_cap.desktop
      cp $out/share/legion_linux /etc/legion_linux
      #sed -i "s@^$out/share/legion_linux@/etc/legion_linux@g" $out/bin/fancurve-set
      #sed -i "s@^$out/share/legion_linux@/etc/legion_linux@g" $out/lib/python3.11/site-packages/legion_linux/legion.py
    '';
    new_postPatch = lib.replaceStrings ["$out/share/legion_linux"] ["/etc/legion_linux"] postPatch;
  in {
    postInstall = new_postInstall;
    postPatch = new_postPatch;
  });
})

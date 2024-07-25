_: (_: super: {
  nekoray_patched = super.nekoray.overrideAttrs (oldAttrs @ {
    postInstall ? "",
    passthru,
    outputs ? ["out"],
    libcap ? super.libcap,
    lib ? super.lib,
    apparmorRulesFromClosure ? super.apparmorRulesFromClosure,
    stdenv ? super.stdenv,
    libidn2 ? super.libidn2,
    ...
  }: let
    new_outputs = outputs ++ ["apparmor"];
    new_postInstall = ''
      mkdir $apparmor

      cat >$apparmor/bin.nekoray_core <<EOF
      include <tunables/global>
      $out/share/nekoray/nekoray_core {
        include <abstractions/base>
        include <abstractions/consoles>
        include <abstractions/nameservice>
        include "${apparmorRulesFromClosure {name = "nekoray_core";}
        ([libcap] ++ lib.optional (!stdenv.hostPlatform.isMusl) libidn2)}"
        include <local/bin.ping>
        capability net_raw,
        network inet raw,
        network inet6 raw,
        mr ${oldAttrs.passthru.nekoray-core}/bin/nekoray_core,
        r @{PROC}/@{pid}/environ,
      }
      EOF

      cat >$apparmor/bin.nekoray_core <<EOF
      include <tunables/global>
      ${oldAttrs.passthru.nekoray-core}/bin/nekoray_core {
        include <abstractions/base>
        include <abstractions/consoles>
        include <abstractions/nameservice>
        include "${apparmorRulesFromClosure {name = "nekoray_core";}
        ([libcap] ++ lib.optional (!stdenv.hostPlatform.isMusl) libidn2)}"
        include <local/bin.ping>
        capability net_raw,
        network inet raw,
        network inet6 raw,
        mr ${oldAttrs.passthru.nekoray-core}/bin/nekoray_core,
        r @{PROC}/@{pid}/environ,
      }
      EOF

      cat >$apparmor/bin.nekobox_core <<EOF
      include <tunables/global>
      $out/share/nekoray/nekobox_core {
        include <abstractions/base>
        include <abstractions/consoles>
        include <abstractions/nameservice>
        include "${apparmorRulesFromClosure {name = "nekobox_core";}
        ([libcap] ++ lib.optional (!stdenv.hostPlatform.isMusl) libidn2)}"
        include <local/bin.ping>
        network inet,
        capability net_admin,
        mr ${oldAttrs.passthru.nekobox-core}/bin/nekobox_core,
        r $out/share/locale/**,
        r @{PROC}/@{pid}/environ,
      }
      EOF

      cat >$apparmor/bin.nekobox_core <<EOF
      include <tunables/global>
      ${oldAttrs.passthru.nekobox-core}/bin/nekobox_core {
        include <abstractions/base>
        include <abstractions/consoles>
        include <abstractions/nameservice>
        include "${apparmorRulesFromClosure {name = "nekobox_core";}
        ([libcap] ++ lib.optional (!stdenv.hostPlatform.isMusl) libidn2)}"
        include <local/bin.ping>
        network inet,
        capability net_admin,
        mr ${oldAttrs.passthru.nekobox-core}/bin/nekobox_core,
        r $out/share/locale/**,
        r @{PROC}/@{pid}/environ,
      }
      EOF
    '';
  in {
    postInstall = new_postInstall;
    outputs = new_outputs;
  });
})

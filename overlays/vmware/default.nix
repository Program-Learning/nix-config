# temporarily fix vmware use overlay
# https://github.com/NixOS/nixpkgs/issues/310121#issuecomment-2118349018
self: (self: super: {
  vmware-workstation = super.vmware-workstation.overrideAttrs (vself: vsuper: let
    urlBase = "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${vself.version}/${vself.build}/linux/";
    file = "VMware-Workstation-${vself.version}-${vself.build}.x86_64.bundle";
    lib = super.lib;
    enableMacOSGuests = false;
  in {
    src = "${self.fetchzip {
      url = urlBase + "core/${file}.tar";
      hash = "sha256-nYkqZ7w3AYdw2YvQNATIYeJpqUwmkLE6jzyQlhGKyEs=";
      stripRoot = false;
    }}/${file}";
    unpackPhase = let
      vmware-unpack-env = self.buildFHSEnv {
        name = "vmware-unpack-env";
        targetPkgs = pkgs: [self.zlib];
      };
      vmware-tools = let
        version = "12.3.5";
        build = "22544099";
        file = system: "vmware-tools-${system}-${version}-${build}.x86_64.component";
        hashes = {
          linux = "sha256-VHFc2g9Bpz7RaJDTB+MXZ2VKe6YfcM1Y2qcqL75mOgw=";
          linuxPreGlibc25 = "sha256-ubxS82tyY/biGSBPvPFsggKLYRXUMVJU9dqNfILa7OY=";
          netware = "sha256-Fs+R4RTgbV+SlFuz7DO/NXdqfMMXf05eSmIfD8AWjvI=";
          solaris = "sha256-HajtvDG/iPUmi7clO2wkSQRMWsOI/rLFHVDlw/vL4wI=";
          winPre2k = "sha256-lX4uvJRFSUIzm6cxCCuZwrsgPuRE2Wr1+GYFY0Qk8Tw=";
          winPreVista = "sha256-xA3UvxIS7u435T0LsyMTCHFUZL9dkTXuekXexOWkXRc=";
          windows = "sha256-/UrzEQTBhmuQODnNoNPQD4pI4MNCxordb/FxVPS3A9o=";
        };
        srcs = map (
          system: "${self.fetchzip {
            url = urlBase + "packages/${file system}.tar";
            hash = hashes.${system};
            stripRoot = false;
          }}/${file system}"
        ) (builtins.attrNames hashes);
      in
        lib.concatMapStringsSep " " (src: "--install-component ${src}") srcs;

      fusionVersion = "13.5.1";
      fusionBuild = "23298085";

      # macOS - ISOs
      darwinIsoSrc = super.fetchurl {
        url = "https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/${fusionVersion}/${fusionBuild}/universal/core/com.vmware.fusion.zip.tar";
        sha256 = "sha256-bn6hoicby2YVj1pZTBzBhabNhKefzVQTm5vIrdTO2K4=";
      };
    in ''
      ${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${vself.src} ${vmware-tools} --extract unpacked"

      ${lib.optionalString enableMacOSGuests ''
        mkdir -p fusion/
        tar -xvpf "${darwinIsoSrc}" -C fusion/
        unzip "fusion/com.vmware.fusion.zip" \
          "payload/VMware Fusion.app/Contents/Library/isoimages/x86_x64/darwin.iso" \
          "payload/VMware Fusion.app/Contents/Library/isoimages/x86_x64/darwinPre15.iso" \
          -d fusion/
      ''}
    '';
  });
})

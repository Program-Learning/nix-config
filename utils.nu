# ================= NixOS related =========================

export def nixos-switch [
    name: string
    mode: string
] {
    print $"mode: ($mode)"
    if "debug" == $mode {
        # show details via nix-output-monitor
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nom build $".#nixosConfigurations.($name).config.system.build.toplevel" --show-trace --verbose
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --use-remote-sudo --flake $".#($name)" --show-trace --verbose --impure
    } else if "boot" == $mode {
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild boot --use-remote-sudo --flake $".#($name)" --impure
    } else if "switch" == $mode {
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --use-remote-sudo --flake $".#($name)" --impure
    } else if "boot-notify" == $mode {
        let new_dir_name = $"result-(date now | format date "%Y-%m-%d_%H:%M:%S")"
        print "NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $\".#($name)\" --impure"
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $".#($name)" --impure
        mv result $new_dir_name
        let msg = "NixOS boot image built successfully. sudo password is required now"
        print $msg
        notify-send -u critical -a NIXOS_REBUILD $msg
        sudo $"($new_dir_name)/bin/switch-to-configuration" boot
        rm $new_dir_name
    } else if "switch-notify" == $mode {
        let new_dir_name = $"result-(date now | format date "%Y-%m-%d_%H:%M:%S")"
        print "NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $\".#($name)\" --impure"
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $".#($name)" --impure
        mv result $new_dir_name
        let msg = "NixOS system configuration built successfully. sudo password is required now"
        print $msg
        notify-send -u critical -a NIXOS_REBUILD $msg
        sudo $"($new_dir_name)/bin/switch-to-configuration" switch
        rm $new_dir_name
    } else {
        let new_dir_name = $"result-(date now | format date "%Y-%m-%d_%H:%M:%S")"
        print "NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $\".#($name)\" --impure"
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $".#($name)" --impure
        mv result $new_dir_name
        let msg = "NixOS system configuration built successfully. sudo password is required now"
        print $msg
        notify-send -u critical -a NIXOS_REBUILD $msg
        sudo $"($new_dir_name)/bin/switch-to-configuration" switch
        rm $new_dir_name
    }
}

# ================= NixOnDroid related =========================

export def nod-switch [
    name: string
    mode: string
] {
    if "debug" == $mode {
        # show details via nix-output-monitor
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nom build $"nixOnDroidConfigurations.#.($name).config.system.build.toplevel" --show-trace --verbose
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nix-on-droid switch --flake $".#($name)" --show-trace --verbose
    } else {
        NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nix-on-droid switch --flake $".#($name)"
    }
}


# ====================== Misc =============================

export def make-editable [
    path: string
] {
    let tmpdir = (mktemp -d)
    rsync -avz --copy-links $"($path)/" $tmpdir
    rsync -avz --copy-links --chmod=D2755,F744 $"($tmpdir)/" $path
}


# ================= macOS related =========================

export def darwin-build [
    name: string
    mode: string
] {
    let target = $".#darwinConfigurations.($name).system"
    if "debug" == $mode {
        nom build $target --extra-experimental-features "nix-command flakes"  --show-trace --verbose
    } else {
        nix build $target --extra-experimental-features "nix-command flakes"
    }
}

export def darwin-switch [
    name: string
    mode: string
] {
    if "debug" == $mode {
        ./result/sw/bin/darwin-rebuild switch --flake $".#($name)" --show-trace --verbose
    } else {
        ./result/sw/bin/darwin-rebuild switch --flake $".#($name)"
    }
}

export def darwin-rollback [] {
    ./result/sw/bin/darwin-rebuild --rollback
}

# ==================== Virtual Machines related =====================

# Build and upload a VM image
export def upload-vm [
    name: string
    mode: string
] {
    let target = $".#($name)"
    if "debug" == $mode {
        nom build $target --show-trace --verbose
    } else {
        nix build $target
    }

    let remote = $"ryan@rakushun:/data/caddy/fileserver/vms/kubevirt-($name).qcow2"
    rsync -avz --progress --copy-links --checksum result $remote
}


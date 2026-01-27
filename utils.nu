def repeat-str [s: string, n: int] {
  (1..$n | each { $s } | str join)
}

# ================= NixOS related =========================

# Run nix command with environment variables and --impure flag
def run-nix-impure [cmd: string] {
  NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 ^$"($cmd) --impure"
}

export def nixos-switch [
    name: string
    mode: string
] {
    print $"nixos-switch '($name)' in '($mode)' mode..."
    print (repeat-str "=" 50)
    let timestamp = (date now | format date "%Y-%m-%d %H:%M:%S")
    if "debug" == $mode {
        # show details via nix-output-monitor
        print $"NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nom build $\".#nixosConfigurations.($name).config.system.build.toplevel\" --show-trace --verbose"
        print $"NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --sudo --flake $\".#($name)\" --show-trace --verbose --impure"
        try {
            NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nom build $".#nixosConfigurations.($name).config.system.build.toplevel" --show-trace --verbose
            NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --sudo --flake $".#($name)" --show-trace --verbose --impure
        } catch {|error|
            let msg = $"NixOS switch failed for '($name)': ($error.msg)"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg
            return
        }
        let msg = $"NixOS switch completed successfully for '($name)'"
        print $msg
        notify-send -u normal -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg -w
    } else if "boot" == $mode {
        try {
            print $"NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild boot --sudo --flake $\".#($name)\" --impure"
            NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild boot --sudo --flake $".#($name)" --impure
        } catch {|error|
            let msg = $"NixOS boot failed for '($name)': ($error.msg)"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg
            return
        }
        let msg = $"NixOS boot completed successfully for '($name)'"
        print $msg
        notify-send -u normal -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg -w
    } else if "switch" == $mode {
        try {
            print $"NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --sudo --flake $\".#($name)\" --impure"
            NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --sudo --flake $".#($name)" --impure
        } catch {|error|
            let msg = $"NixOS switch failed for '($name)': ($error.msg)"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg
            return
        }
        let msg = $"NixOS switch completed successfully for '($name)'"
        print $msg
        notify-send -u normal -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg -w
    } else if "boot-notify" == $mode {
        let new_dir_name = $"result-(date now | format date "%Y-%m-%d_%H:%M:%S")"
        try {
            print $"NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $\".#($name)\" --impure"
            NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $".#($name)" --impure
            mv result $new_dir_name
            let msg = "NixOS boot image built successfully. sudo password is required now"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg -w
            sudo nix-env -p /nix/var/nix/profiles/system --set $"./($new_dir_name)"
            rm $new_dir_name
        } catch {|error|
            let msg = $"NixOS boot build failed for '($name)': ($error.msg)"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg
            if ($new_dir_name | path exists) {
                rm $new_dir_name
            }
            return
        }
    } else if "switch-notify" == $mode {
        let new_dir_name = $"result-(date now | format date "%Y-%m-%d_%H:%M:%S")"
        try {
            print $"NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $\".#($name)\" --impure"
            NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $".#($name)" --impure
            mv result $new_dir_name
            let msg = "NixOS system configuration built successfully. sudo password is required now"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg -w
            sudo nix-env -p /nix/var/nix/profiles/system --set $"./($new_dir_name)"
            sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration $"($new_dir_name)/bin/switch-to-configuration" switch
            rm $new_dir_name
        } catch {|error|
            let msg = $"NixOS switch build failed for '($name)': ($error.msg)"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg
            if ($new_dir_name | path exists) {
                rm $new_dir_name
            }
            return
        }
    } else {
        let new_dir_name = $"result-(date now | format date "%Y-%m-%d_%H:%M:%S")"
        try {
            print $"NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $\".#($name)\" --impure"
            NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild build --flake $".#($name)" --impure
            mv result $new_dir_name
            let msg = "NixOS system configuration built successfully. sudo password is required now"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg -w
            sudo nix-env -p /nix/var/nix/profiles/system --set $"./($new_dir_name)"
            sudo systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration $"($new_dir_name)/bin/switch-to-configuration" switch
            rm $new_dir_name
        } catch {|error|
            let msg = $"NixOS switch build failed for '($name)': ($error.msg)"
            print $msg
            notify-send -u critical -a "nixos-rebuild" -p $"NIXOS_REBUILD_($timestamp)" $msg
            if ($new_dir_name | path exists) {
                rm $new_dir_name
            }
            return
        }
    }
}

# ================= NixOnDroid related =========================

export def nod-switch [
    name: string
    mode: string
] {
    print $"mode: ($mode)"
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
    print (repeat-str "=" 50)
    let tmpdir = (mktemp -d)
    rsync -avz --copy-links $"($path)/" $tmpdir
    rsync -avz --copy-links --chmod=D2755,F744 $"($tmpdir)/" $path
}


# ================= macOS related =========================

export def darwin-build [
    name: string
    mode: string
] {
    print $"darwin-build '($name)' in '($mode)' mode..."
    print (repeat-str "=" 50)
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
    print $"darwin-switch '($name)' in '($mode)' mode..."
    print (repeat-str "=" 50)
    if "debug" == $mode {
        sudo -E ./result/sw/bin/darwin-rebuild switch --flake $".#($name)" --show-trace --verbose
    } else {
        sudo -E ./result/sw/bin/darwin-rebuild switch --flake $".#($name)"
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
    print $"upload-vm '($name)' in '($mode)' mode..."
    print (repeat-str "=" 50)
    let target = $".#($name)"
    if "debug" == $mode {
        nom build $target --show-trace --verbose
    } else {
        nix build $target
    }

    let remote = $"ryan@rakushun:/data/caddy/fileserver/vms/kubevirt-($name).qcow2"
    rsync -avz --progress --copy-links --checksum result $remote
}

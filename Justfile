# just is a command runner, Justfile is very similar to Makefile, but simpler.

# use nushell for shell commands
set shell := ["nu", "-c"]

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

nixos-switch := "nixos-rebuild switch --use-remote-sudo --flake"
nixos-boot := "nixos-rebuild boot --use-remote-sudo --flake"
debug-args := "--show-trace --verbose"

y9000k2021h_i3:
  {{nixos-switch}} .#y9000k2021h_i3

y9000k2021h_hypr:
	{{nixos-switch}} .#y9000k2021h_hyprland

i3:
  {{nixos-switch}} .#ai_i3

hypr:
	{{nixos-switch}} .#ai_hyprland

s-i3:
	{{nixos-switch}} .#shoukei_i3

s-hypr:
	{{nixos-switch}} .#shoukei_hyprland

y9000k2021h_i3-debug:
  {{nixos-switch}} .#y9000k2021h_i3 {{debug-args}}

y9000k2021h_hypr-debug:
	{{nixos-switch}} .#y9000k2021h_hyprland {{debug-args}}

i3-debug:
	{{nixos-switch}} .#ai_i3 {{debug-args}}

hypr-debug:
	{{nixos-switch}} .#ai_hyprland {{debug-args}}

up:
  nix flake update

# Update specific input
# Usage: just upp nixpkgs
upp input:
  nix flake lock --update-input {{input}}

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug

############################################################################
#
#  Darwin related commands, harmonica is my macbook pro's hostname
#
############################################################################

darwin-prefix := "./result/sw/bin/darwin-rebuild"
darwin-switch := "{{darwin-prefix}} switch --flake"

darwin-set-proxy:
  sudo python3 scripts/darwin_set_proxy.py
  sleep 1

darwin-rollback:
  {{darwin-prefix}} rollback

ha: darwin-set-proxy
  nix build .#darwinConfigurations.harmonica.system
  {{darwin-switch}} .#harmonica

ha-debug: darwin-set-proxy
  nom build .#darwinConfigurations.harmonica.system {{debug-args}}
  {{darwin-switch}} .#harmonica {{debug-args}}

fe: darwin-set-proxy
  nix build .#darwinConfigurations.fern.system
  {{darwin-switch}} .#fern

fe-debug: darwin-set-proxy
  nom build .#darwinConfigurations.fern.system {{debug-args}}
  {{darwin-switch}} .#fern {{debug-args}}

############################################################################
#
#  Idols, Commands related to my remote distributed building cluster
#
############################################################################

idols-ssh-key:
  ssh-add ~/.ssh/ai-idols

idols: idols-ssh-key
  colmena apply --on '@dist-build'

aqua:
  colmena apply --on '@aqua'

ruby:
  colmena apply --on '@ruby'

kana:
  colmena apply --on '@kana'

idols-debug: idols-ssh-key
  colmena apply --on '@dist-build' --verbose --show-trace

# only used once to setup the virtual machines
idols-image:
  # take image for idols, and upload the image to proxmox nodes.
  nom build .#aquamarine
  scp result root@gtr5:/var/lib/vz/dump/vzdump-qemu-aquamarine.vma.zst

  nom build .#ruby
  scp result root@s500plus:/var/lib/vz/dump/vzdump-qemu-ruby.vma.zst

  nom build .#kana
  scp result root@um560:/var/lib/vz/dump/vzdump-qemu-kana.vma.zst


############################################################################
#
#  RISC-V related commands
#    
############################################################################

roll: idols-ssh-key
  colmena apply --on '@riscv' 

roll-debug: idols-ssh-key
  colmena apply --on '@dist-build' --verbose --show-trace

nozomi:
  colmena apply --on '@nozomi'

yukina:
  colmena apply --on '@yukina'

############################################################################
#
# Aarch64 related commands
#
############################################################################

aarch:
  colmena apply --on '@aarch'

suzu:
  colmena apply --on '@suzu'

suzu-debug:
  colmena apply --on '@suzu' --verbose --show-trace

############################################################################
#
#  Misc, other useful commands
#
############################################################################

fmt:
  # format the nix files in this repo
  nix fmt


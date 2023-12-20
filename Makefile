#
#  NOTE: Makefile's target name should not be the same as one of the file or directory in the current directory, 
#    otherwise the target will not be executed!
#


############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

i3: 
	nixos-rebuild switch --flake .#y9000k2021h_i3 --use-remote-sudo

hypr:
	nixos-rebuild switch --flake .#y9000k2021h_hyprland --use-remote-sudo

i3-debug:
	nixos-rebuild switch --flake .#y9000k2021h_i3 --use-remote-sudo --show-trace --verbose

hypr-debug:
	nixos-rebuild switch --flake .#y9000k2021h_hyprland --use-remote-sudo --show-trace --verbose

up:
	nix flake update

# Update specific input
# usage: make upp i=wallpapers
upp:
	nix flake lock --update-input $(i)

history:
	nix profile history --profile /nix/var/nix/profiles/system

repl:
	nix repl -f flake:nixpkgs

eye:
	systemctl --user start gammastep.service

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	# sudo nix store gc --debug

############################################################################
#
#  My often-used command
#
############################################################################

nur_all := nur-program-learning nur-ryan4yin nur-linyinfeng nur-xddxdd nur-AtaraxiaSjel nur-arti5an

# Update nur inputs 
# (can use with ''
# proxychains4 make update_nur
# '' 
# or ''
# http_proxy='http://localhost:7890' https_proxy='http://localhost:7890' make update_nur 
# '')
update_nur:
	$(foreach repo,$(nur_all)\
		,nix flake lock --update-input $(repo) &&) true

upgrade_switch_system:
	sudo NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 http_proxy='http://localhost:7890' https_proxy='http://localhost:7890' nixos-rebuild switch --flake /home/nixos/Documents/code/nix-config/#y9000k2021h_hyprland --upgrade --impure --show-trace

upgrade_system:
	sudo NIXPKGS_ALLOW_BROKEN=1 NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 http_proxy='http://localhost:7890' https_proxy='http://localhost:7890' nixos-rebuild boot --flake /home/nixos/Documents/code/nix-config/#y9000k2021h_hyprland --upgrade --impure --show-trace

############################################################################
#
#  Darwin related commands, harmonica is my macbook pro's hostname
#
############################################################################

darwin-set-proxy:
	sudo python3 scripts/darwin_set_proxy.py
	sleep 1

ha: darwin-set-proxy
	nix build .#darwinConfigurations.harmonica.system
	./result/sw/bin/darwin-rebuild switch --flake .#harmonica
	sleep 1

ha-rollback:
	./result/sw/bin/darwin-rebuild rollback

ha-debug: darwin-set-proxy
	nom build .#darwinConfigurations.harmonica.system --show-trace --verbose
	./result/sw/bin/darwin-rebuild switch --flake .#harmonica --show-trace --verbose
	sleep 1

############################################################################
#
#  Idols, Commands related to my remote distributed building cluster
#
############################################################################

add-idols-ssh-key:
	ssh-add ~/.ssh/ai-idols

idols: add-idols-ssh-key
	colmena apply --on '@dist-build'

aqua:
	colmena apply --on '@aqua'

ruby:
	colmena apply --on '@ruby'

kana:
	colmena apply --on '@kana'

idols-debug: add-idols-ssh-key
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
#	RISC-V related commands
#		
############################################################################

roll: add-idols-ssh-key
	colmena apply --on '@riscv' 

roll-debug: add-idols-ssh-key
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

.PHONY: clean  
clean:  
	rm -rf result

.PHONY: test all clean update-sops-files

update-sops-files: tmp/make/lastUpdateSOPS

tmp/make/lastUpdateSOPS: sops.yaml.nix pubkeys.json sops/* makefile
	echo "# AUTOMATICALLY GENERATED WITH:" > .sops.yaml.tmp
	echo "# make update-sops-files" >> .sops.yaml.tmp
	nix eval --json -f sops.yaml.nix | yq e -P - >> .sops.yaml.tmp
	mv .sops.yaml.tmp .sops.yaml
	mkdir -vp tmp/make
	touch tmp/make/lastUpdateSOPS

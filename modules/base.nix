{
  pkgs,
  myvars,
  nuenv,
  nixpkgs,
  lib,
  nur-xddxdd,
  nur-DataEraserC,
  ...
} @ args: {
  nixpkgs.overlays =
    [
      nuenv.overlays.default
    ]
    ++ (import ../overlays args);

  # Add my private PKI's CA certificate to the system-wide trust store.
  security.pki.certificateFiles = [
    ../certs/ecc-ca.crt
  ];

  # auto upgrade nix to the unstable version
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/nix/default.nix#L284
  # nix.package = pkgs.nixVersions.latest;
  nix.package = pkgs.nixVersions.nix_2_22;

  environment.systemPackages = with pkgs; [
    git # used by nix flakes
    git-lfs # used by huggingface models

    # archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # Text Processing
    # Docs: https://github.com/learnbyexample/Command-line-text-processing
    gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
    gnused # GNU sed, very powerful(mainly for replacing text in files)
    gawk # GNU awk, a pattern scanning and processing language
    jq # A lightweight and flexible command-line JSON processor

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    wget
    curl
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    findutils
    which
    tree
    gnutar
    rsync
  ];

  users.users.${myvars.username} = {
    description = myvars.userfullname;
    # Public Keys that can be used to login to all my PCs, Macbooks, and servers.
    #
    # Since its authority is so large, we must strengthen its security:
    # 1. The corresponding private key must be:
    #    1. Generated locally on every trusted client via:
    #      ```bash
    #      # KDF: bcrypt with 256 rounds, takes 2s on Apple M2):
    #      # Passphrase: digits + letters + symbols, 12+ chars
    #      ssh-keygen -t ed25519 -a 256 -C "ryan@xxx" -f ~/.ssh/xxx`
    #      ```
    #    2. Never leave the device and never sent over the network.
    # 2. Or just use hardware security keys like Yubikey/CanoKey.
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes" "ca-derivations"];

    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = [myvars.username];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

      "https://nix-community.cachix.org"
      # my own cache server
      "https://ryan4yin.cachix.org"
      nur-xddxdd.meta.cachixUrl
      nur-DataEraserC.meta.cachixUrl
      "https://linyinfeng.cachix.org"
      # cuda-maintainer's cache server
      "https://cuda-maintainers.cachix.org"
      "https://program-learning.cachix.org"
      "https://ai.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ryan4yin.cachix.org-1:Gbk27ZU5AYpGS9i3ssoLlwdvMIh0NxG0w8it/cv9kbU="
      nur-xddxdd.meta.cachixPublicKey
      nur-DataEraserC.meta.cachixPublicKey
      "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "program-learning.cachix.org-1:Pfl2r+J5L9wJqpDnop6iQbrR3/Ts4AUyotu89INRlSU="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    builders-use-substitutes = true;
  };

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;

  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  # discard all the default paths, and only use the one from this flake.
  nix.nixPath = lib.mkForce ["/etc/nix/inputs"];
  # https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
}

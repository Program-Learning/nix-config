{
  description = "Ryan Yin's nix configuration for both NixOS & macOS";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  outputs = inputs: import ./outputs inputs;

  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://ezkea.cachix.org"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-latest.url = "github:nixos/nixpkgs?ref=master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable-yuzu.url = "github:nixos/nixpkgs?rev=6a59b7def496268fc32175183e4041d92586b00b";
    nixpkgs-unstable-etcher.url = "github:nixos/nixpkgs?rev=15cf1bacec81d3905d40b8005f88bb3ad8dc5a56";

    # for macos
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # for nix-on-droid
    nixpkgs-nod.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable-nod.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager-nod = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-nod";
    };

    fakedroid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-nod";
      inputs.home-manager.follows = "home-manager-nod";
    };

    nur-ryan4yin-nod = {
      url = "github:ryan4yin/nur-packages";
      # inputs.nixpkgs.follows = "nixpkgs-nod";
    };

    catppuccin-urxvt = {
      url = "github:catppuccin/urxvt/ccd8eb763edd0a382b5e9bbfbd9697c4d4129edf";
      flake = false;
    };

    # AstroNvim is an aesthetic and feature-rich neovim config.
    astronvim-nod = {
      url = "github:AstroNvim/AstroNvim/v3.37.12";
      flake = false;
    };

    nur-program-learning-nod = {
      url = "github:Program-Learning/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs-nod";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # url = "github:nix-community/home-manager/master";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.39.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins/e9457e08ca3ff16dc5a815be62baf9e18b539197";
      inputs.hyprland.follows = "hyprland";
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace/a44d834af279f233a269d065d2e14fe4101d6f41";

      # Hyprspace uses latest Hyprland. We declare this to keep them in sync.
      inputs.hyprland.follows = "hyprland";
    };

    hycov = {
      url = "github:DreamMaoMao/hycov/05fb15703d07a372b14a3260a337de13d1c16b91";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      url = "github:pyt0xic/hyprfocus/e44b956dd4b7507489219bd2b02a3886d547b7e2";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-easymotion = {
      url = "github:DreamMaoMao/hyprland-easymotion/a1a4969ddf68dc78be024a0fdf4ce1f8f6b9d74d";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    browser-previews = {
      url = "github:r-k-b/browser-previews";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # community wayland nixpkgs
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # anyrun - a wayland launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # secrets management
    agenix = {
      # lock with git commit at 0.15.0
      # url = "github:ryantm/agenix/564595d0ad4be7277e07fa63b5a991b3c645655d";
      # replaced with a type-safe reimplementation to get a better error message and less bugs.
      url = "github:ryan4yin/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    disko = {
      url = "github:nix-community/disko/v1.6.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nuenv.url = "github:DeterminateSystems/nuenv";

    daeuniverse.url = "github:daeuniverse/flake.nix";
    # daeuniverse.url = "github:daeuniverse/flake.nix/exp";

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ######################## dots_hyprland required  #########################################

    DataEraserC-dots_hyprland = {
      url = "github:DataEraserC/dots-hyprland";
      # url = "git+file:////home/nixos/Documents/code/dots-hyprland?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ########################  Some non-flake repositories  #########################################

    # doom-emacs is a configuration framework for GNU Emacs.
    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };

    polybar-themes = {
      url = "github:adi1090x/polybar-themes";
      flake = false;
    };

    ########################  My own repositories  #########################################

    # my private secrets, it's a private repository, you need to replace it with your own.
    # use ssh protocol to authenticate via ssh-agent/ssh-key, and shallow clone to save time
    mysecrets = {
      url = "git+ssh://git@github.com/DataEraserC/nix-secrets.git?shallow=1";
      # url = "git+file:////home/nixos/Documents/code/nix-config/secrets?shallow=1";
      flake = false;
    };

    # my wallpapers
    wallpapers = {
      url = "github:Program-Learning/wallpapers/dark_wallpapers";
      # url = "git+file:////home/nixos/Documents/code/wallpapers?shallow=1";
      flake = false;
    };

    nixified-ai = {
      url = "github:Program-Learning/nixified-ai-flake";
      inputs.nixpkgs.follows = "nixified-ai-nixpkgs";
    };

    LaphaeL-aicmd = {
      url = "github:DataEraserC/LaphaeL-aicmd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixified-ai-nixpkgs.url = "github:nixos/nixpkgs/c757e9bd77b16ca2e03c89bf8bc9ecb28e0c06ad";

    # NUR package source

    nur.url = "github:nix-community/NUR";

    nur-ryan4yin = {
      url = "github:ryan4yin/nur-packages";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-program-learning = {
      url = "github:Program-Learning/nur-packages";
      # url = "gitfile:////home/nixos/Documents/code/program-learning-nur-packages?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llqqnt = {
      url = "github:DataEraserC/nur-packages";
      # url = "gitfile:////home/nixos/Documents/code/program-learning-nur-packages?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gradle2nix = {
      url = "github:tadfisher/gradle2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.flake-utils.follows = "flake-utils";
    };

    nur-linyinfeng = {
      url = "github:linyinfeng/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-DataEraserC = {
      url = "github:DataEraserC/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-AtaraxiaSjel = {
      url = "github:AtaraxiaSjel/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";

      # The main branch follows the "canary" channel of the Android SDK
      # repository. Use another android-nixpkgs branch to explicitly
      # track an SDK release channel.
      #
      # url = "github:tadfisher/android-nixpkgs/stable";
      # url = "github:tadfisher/android-nixpkgs/beta";
      # url = "github:tadfisher/android-nixpkgs/preview";
      # url = "github:tadfisher/android-nixpkgs/canary";

      # If you have nixpkgs as an input, this will replace the "nixpkgs" input
      # for the "android" flake.
      #
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/0.1.9.tar.gz";

    # riscv64 SBCs
    nixos-licheepi4a.url = "github:ryan4yin/nixos-licheepi4a";
    # nixos-jh7110.url = "github:ryan4yin/nixos-jh7110";

    # aarch64 SBCs
    nixos-rk3588.url = "github:ryan4yin/nixos-rk3588";
  };
}

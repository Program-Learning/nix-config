let
  desktop_base_modules = {
    nixos-modules = [
      ../secrets/nixos.nix
      ../modules/nixos/desktop.nix
    ];
    home-module.imports = [
      ../home/linux/desktop.nix
    ];
  };
in {
  # y9000k2021h
  idol_y9000k2021h_modules_i3 = {
    nixos-modules =
      [
        ../hosts/idols_y9000k2021h
        {modules.desktop.xorg.enable = true;}
      ]
      ++ desktop_base_modules.nixos-modules;
    home-module.imports =
      [
        ../hosts/idols_y9000k2021h/home.nix
        {modules.desktop.i3.enable = true;}
      ]
      ++ desktop_base_modules.home-module.imports;
  };

  idol_y9000k2021h_modules_hyprland = {
    nixos-modules =
      [
        ../hosts/idols_y9000k2021h
        {modules.desktop.wayland.enable = true;}
      ]
      ++ desktop_base_modules.nixos-modules;
    home-module.imports =
      [
        ../hosts/idols_y9000k2021h/home.nix
        {modules.desktop.hyprland.enable = true;}
      ]
      ++ desktop_base_modules.home-module.imports;
  };

  # 星野 アイ, Hoshino Ai
  idol_ai_modules_i3 = {
    nixos-modules =
      [
        ../hosts/idols_ai
        {modules.desktop.xorg.enable = true;}
      ]
      ++ desktop_base_modules.nixos-modules;
    home-module.imports =
      [
        ../hosts/idols_ai/home.nix
        {modules.desktop.i3.enable = true;}
      ]
      ++ desktop_base_modules.home-module.imports;
  };

  idol_ai_modules_hyprland = {
    nixos-modules =
      [
        ../hosts/idols_ai
        {modules.desktop.wayland.enable = true;}
      ]
      ++ desktop_base_modules.nixos-modules;
    home-module.imports =
      [
        ../hosts/idols_ai/home.nix
        {modules.desktop.hyprland.enable = true;}
      ]
      ++ desktop_base_modules.home-module.imports;
  };

  # 星野 愛久愛海, Hoshino Akuamarin
  idol_aquamarine_modules = {
    nixos-modules = [
      ../hosts/idols_aquamarine
      ../modules/nixos/server.nix
      ../modules/nixos/proxmox-hardware-configuration.nix
    ];
    home-module.imports = [
      ../hosts/idols_aquamarine/home.nix
      ../home/linux/server.nix
    ];
  };
  idol_aquamarine_tags = ["dist-build" "aqua"];

  # 星野 瑠美衣, Hoshino Rubii
  idol_ruby_modules = {
    nixos-modules = [
      ../hosts/idols_ruby
      ../modules/nixos/server.nix
      ../modules/nixos/proxmox-hardware-configuration.nix
    ];
    home-module.imports = [
      ../hosts/idols_ruby/home.nix
      ../home/linux/server.nix
    ];
  };
  idol_ruby_tags = ["dist-build" "ruby"];

  # 有馬 かな, Arima Kana
  idol_kana_modules = {
    nixos-modules = [
      ../hosts/idols_kana
      ../modules/nixos/server.nix
      ../modules/nixos/proxmox-hardware-configuration.nix
    ];
    home-module.imports = [
      ../hosts/idols_kana/home.nix
      ../home/linux/server.nix
    ];
  };
  idol_kana_tags = ["dist-build" "kana"];

  # 森友 望未, Moritomo Nozomi
  rolling_nozomi_modules = {
    nixos-modules = [
      ../hosts/rolling_girls_nozomi
      ../modules/nixos/server-riscv64.nix

      # cross-compilation this flake.
      {nixpkgs.crossSystem.system = "riscv64-linux";}
    ];
    # home-module.imports = [];
  };
  rolling_nozomi_tags = ["riscv" "nozomi"];

  # 小坂 結季奈, Kosaka Yukina
  rolling_yukina_modules = {
    nixos-modules = [
      ../hosts/rolling_girls_yukina
      ../modules/nixos/server-riscv64.nix

      # cross-compilation this flake.
      {nixpkgs.crossSystem.system = "riscv64-linux";}
    ];
    # home-module.imports = [];
  };
  rolling_yukina_tags = ["riscv" "yukina"];

  # 大木 鈴, Ōki Suzu
  _12kingdoms_suzu_modules = {
    nixos-modules = [
      ../hosts/12kingdoms_suzu
      ../modules/nixos/server-riscv64.nix

      # cross-compilation this flake.
      {nixpkgs.crossSystem.config = "aarch64-unknown-linux-gnu";}
    ];
    # home-module.imports = [];
  };
  _12kingdoms_suzu_tags = ["aarch" "suzu"];

  # Shoukei (祥瓊, Shōkei)
  _12kingdoms_shoukei_modules_i3 = {
    nixos-modules =
      [
        ../hosts/12kingdoms_shoukei
        {modules.desktop.xorg.enable = true;}
      ]
      ++ desktop_base_modules.nixos-modules;
    home-module.imports =
      [
        ../hosts/12kingdoms_shoukei/home.nix
        {modules.desktop.i3.enable = true;}
      ]
      ++ desktop_base_modules.home-module.imports;
  };

  _12kingdoms_shoukei_modules_hyprland = {
    nixos-modules =
      [
        ../hosts/12kingdoms_shoukei
        {modules.desktop.wayland.enable = true;}
      ]
      ++ desktop_base_modules.nixos-modules;
    home-module.imports =
      [
        ../hosts/12kingdoms_shoukei/home.nix
        {modules.desktop.hyprland.enable = true;}
      ]
      ++ desktop_base_modules.home-module.imports;
  };

  # darwin systems
  darwin_harmonica_modules = {
    darwin-modules = [
      ../hosts/darwin_harmonica

      ../modules/darwin
      ../secrets/darwin.nix
    ];
    home-module.imports = [
      ../hosts/darwin_harmonica/home.nix
      ../home/darwin
    ];
  };
  darwin_fern_modules = {
    darwin-modules = [
      ../hosts/darwin_fern

      ../modules/darwin
      ../secrets/darwin.nix
    ];
    home-module.imports = [
      ../hosts/darwin_fern/home.nix
      ../home/darwin
    ];
  };
}

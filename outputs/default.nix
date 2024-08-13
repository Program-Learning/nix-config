{
  self,
  nixpkgs,
  pre-commit-hooks,
  ...
} @ inputs: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../lib {inherit lib;};
  myvars = import ../vars {inherit lib;};

  # Add my custom lib, vars, nixpkgs instance, and all the inputs to specialArgs,
  # so that I can use them in all my nixos/home-manager/darwin modules.
  genSpecialArgs = system:
    inputs
    // {
      inherit mylib myvars;

      # use unstable branch for some packages to get the latest updates
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-latest = import inputs.nixpkgs-latest {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-unstable-yuzu = import inputs.nixpkgs-unstable-yuzu {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      pkgs-unstable-etcher = import inputs.nixpkgs-unstable-etcher {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      # Temporary input
      pkgs-jadx-fix = import inputs.nixpkgs-unstable-jadx {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
    };

  # This is the args for all the haumea modules in this folder.
  args = {inherit inputs lib mylib myvars genSpecialArgs;};

  # modules for each supported system
  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // {system = "x86_64-linux";});
    aarch64-linux = import ./aarch64-linux (args // {system = "aarch64-linux";});
    riscv64-linux = import ./riscv64-linux (args // {system = "riscv64-linux";});
  };
  wslSystems = {
    x86_64-wsl = import ./x86_64-wsl (args // {system = "x86_64-linux";});
    # aarch64-wsl = import ./aarch64-wsl (args // {system = "aarch64-linux";});
  };
  darwinSystems = {
    aarch64-darwin = import ./aarch64-darwin (args // {system = "aarch64-darwin";});
    x86_64-darwin = import ./x86_64-darwin (args // {system = "x86_64-darwin";});
  };
  droidSystems = {
    aarch64-droid = import ./aarch64-droid (args // {system = "aarch64-linux";});
    # x86_64-droid = import ./x86_64-droid (args // {system = "x86_64-linux";});
  };
  allSystems = nixosSystems // darwinSystems // droidSystems // wslSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  droidSystemValues = builtins.attrValues droidSystems;
  wslSystemValues = builtins.attrValues wslSystems;
  allSystemValues = nixosSystemValues ++ darwinSystemValues ++ droidSystemValues ++ wslSystemValues;

  # Helper function to generate a set of attributes for each system
  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
in rec {
  # Add attribute sets into outputs, for debugging
  debugAttrs = {inherit nixosSystems darwinSystems droidSystems wslSystems allSystems allSystemNames;};

  # NixOS Hosts
  nixosConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosSystemValues) // wslConfigurations;

  # Colmena - remote deployment via SSH
  colmena =
    {
      meta =
        (
          let
            system = "x86_64-linux";
          in {
            # colmena's default nixpkgs & specialArgs
            nixpkgs = import nixpkgs {inherit system;};
            specialArgs = genSpecialArgs system;
          }
        )
        // {
          # per-node nixpkgs & specialArgs
          nodeNixpkgs = lib.attrsets.mergeAttrsList (map (it: it.colmenaMeta.nodeNixpkgs or {}) nixosSystemValues);
          nodeSpecialArgs = lib.attrsets.mergeAttrsList (map (it: it.colmenaMeta.nodeSpecialArgs or {}) nixosSystemValues);
        };
    }
    // lib.attrsets.mergeAttrsList (map (it: it.colmena or {}) nixosSystemValues);

  # macOS Hosts
  darwinConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.darwinConfigurations or {}) darwinSystemValues);

  # droid Hosts
  nixOnDroidConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixOnDroidConfigurations or {}) droidSystemValues);

  # WSL Hosts
  wslConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) wslSystemValues);

  # Packages
  packages = forAllSystems (
    system: allSystems.${system}.packages or {}
  );

  # Eval Tests for all NixOS & darwin systems.
  evalTests = lib.lists.all (it: it.evalTests == {}) allSystemValues;

  checks = forAllSystems (
    system: {
      # eval-tests per system
      eval-tests = allSystems.${system}.evalTests == {};

      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = mylib.relativeToRoot ".";
        hooks = {
          alejandra.enable = true; # formatter
          # Source code spell checker
          typos = {
            enable = true;
            settings = {
              write = true; # Automatically fix typos
              configPath = "./.typos.toml"; # relative to the flake root
            };
          };
          prettier = {
            enable = true;
            settings = {
              write = true; # Automatically format files
              configPath = "./.prettierrc.yaml"; # relative to the flake root
            };
          };
          # deadnix.enable = true; # detect unused variable bindings in `*.nix`
          # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
        };
      };
    }
  );

  # Development Shells
  devShells = forAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
          bashInteractive
          # fix `cc` replaced by clang, which causes nvim-treesitter compilation error
          gcc
          # Nix-related
          alejandra
          deadnix
          statix
          # spell checker
          typos
          # code formatter
          nodePackages.prettier
        ];
        name = "dots";
        shellHook = ''
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
      # TODO: move this to devshell dir
      mariadb = pkgs.mkShell {
        buildInputs = [pkgs.mariadb];
        shellHook = ''
          MYSQL_BASEDIR=${pkgs.mariadb}
          MYSQL_HOME=$PWD/mysql
          MYSQL_DATADIR=$MYSQL_HOME/data
          export MYSQL_UNIX_PORT=$MYSQL_HOME/mysql.sock
          MYSQL_PID_FILE=$MYSQL_HOME/mysql.pid
          alias mysql='mysql -u root'

          if [ ! -d "$MYSQL_HOME" ]; then
            # Make sure to use normal authentication method otherwise we can only
            # connect with unix account. But users do not actually exists in nix.
            mysql_install_db --auth-root-authentication-method=normal \
              --datadir=$MYSQL_DATADIR --basedir=$MYSQL_BASEDIR \
              --pid-file=$MYSQL_PID_FILE
          fi

          # Starts the daemon
          mysqld --datadir=$MYSQL_DATADIR --pid-file=$MYSQL_PID_FILE \
            --socket=$MYSQL_UNIX_PORT 2> $MYSQL_HOME/mysql.log &
          MYSQL_PID=$!

          finish()
          {
            mysqladmin -u root --socket=$MYSQL_UNIX_PORT shutdown
            kill $MYSQL_PID
            wait $MYSQL_PID
          }
          trap finish EXIT
        '';
      };
    }
  );

  # Format the nix code in this flake
  formatter = forAllSystems (
    # alejandra is a nix formatter with a beautiful output
    system: nixpkgs.legacyPackages.${system}.alejandra
  );
}

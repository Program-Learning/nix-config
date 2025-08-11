{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
with lib;
let
  cfg = config.features.bigdata_hadoop;
in
{
  options = {
    features.bigdata_hadoop = {
      enable = mkEnableOption (lib.mdDoc "hadoop instance required by bigdata lesson");
      package = lib.mkPackageOption pkgs "hadoop" { };
      impermanence.enable = mkEnableOption "whether use impermanence and ephemeral root file system";
    };
  };

  # IDK why config.environment.persistence != null do not work
  config =
    mkIf (cfg.enable && cfg.impermanence.enable) {
      environment.persistence."/persistent" = {
        users.hadoop = {
          directories = [
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".ssh";
              mode = "0700";
            }
          ];
        };
      };
    }
    // mkIf cfg.enable {
      environment.variables = {
        HADOOP_HOME = "${cfg.package}";
        JAVA_HOME = "${pkgs.jdk11_headless}";
      };
      system.activationScripts.hadoop_init_mkdir = {
        deps = [ "var" ];
        text = ''
          mkdir -p /tmp/hadoop/hadoop
          chown hadoop:hadoop -R /tmp/hadoop/hadoop
          mkdir -p /var/lib/hadoop/tmp/dfs/data
          chown hadoop:hadoop -R /var/lib/hadoop/tmp/dfs/data
          mkdir -p /var/lib/hadoop/tmp/dfs/name
          chown hadoop:hadoop -R /var/lib/hadoop/tmp/dfs/name
        '';
      };
      networking.extraHosts = lib.mkForce "127.0.0.1 localhost";
      users.users.hadoop = {
        initialHashedPassword = "$7$CU..../....zmajtL8laTkw0keUfR4ZC1$lcF.YgINaXfQCDzOuR9dIZ9Hc6of2IqiNaJ3mRKn70B";
        hashedPassword = "$7$CU..../....zmajtL8laTkw0keUfR4ZC1$lcF.YgINaXfQCDzOuR9dIZ9Hc6of2IqiNaJ3mRKn70B";
        isNormalUser = true;
        group = "hadoop";
        extraGroups = [ "wheel" ];
        packages = [
          pkgs.jdk11_headless
        ];
      };
      services.hadoop = {
        package = cfg.package;
        gatewayRole.enable = true;
        coreSite = {
          "fs.defaultFS" = "hdfs://localhost:9000";
        };
        hdfsSite = {
          "dfs.replication" = "1";
        };
        mapredSite = {
          "mapreduce.framework.name" = "yarn";
        };
        yarnSite = {
          "yarn.nodemanager.aux-services" = "mapreduce_shuffle";
        };
      };
    };
}

{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
with lib; let
  cfg = config.features.bigdata_hadoop;
in {
  options = {
    features.bigdata_hadoop = {
      enable = mkEnableOption (lib.mdDoc "hadoop instance required by bigdata lesson");
      package = lib.mkPackageOption pkgs "hadoop" {};
    };
  };

  config = mkIf cfg.enable {
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
    environment.variables = {
      HADOOP_HOME = "${cfg.package}";
      JAVA_HOME = "${pkgs.jdk11_headless}";
    };
    networking.extraHosts = lib.mkForce "";
    users.users.hadoop = {
      inherit (myvars) initialHashedPassword hashedPassword;
      isNormalUser = true;
      group = "hadoop";
      extraGroups = ["wheel"];
      packages = [
        pkgs.jdk11_headless
      ];
    };
    services.hadoop = {
      package = cfg.package;
      gatewayRole.enable = true;
      coreSite = {
        "fs.defaultFS" = "hdfs://localhost:9000";
        "hadoop.tmp.dir" = "file:/var/lib/hadoop/tmp";
      };
      hdfsSite = {
        "dfs.replication" = "1";
        "dfs.namenode.name.dir" = "file:/var/lib/hadoop/tmp/dfs/name";
        "dfs.datanode.data.dir" = "file:/var/lib/hadoop/tmp/dfs/data";
      };
    };
  };
}

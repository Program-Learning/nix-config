{
  config,
  lib,
  pkgs,
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
    environment.variables = {
      HADOOP_HOME = "${cfg.package}";
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

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.frp;
  settingsFormat = pkgs.formats.toml { };
  enabledInstances = lib.filterAttrs (name: conf: conf.enable) cfg.instances;
in
{
  imports = [
    # (lib.mkRenamedOptionModule
    #   [ "services" "frp" "enable" ]
    #   [ "modules" "frp" "instances" "" "enable" ]
    # )
    # (lib.mkRenamedOptionModule [ "services" "frp" "role" ] [ "modules" "frp" "instances" "" "role" ])
    # (lib.mkRenamedOptionModule
    #   [ "services" "frp" "settings" ]
    #   [ "modules" "frp" "instances" "" "settings" ]
    # )
  ];

  options = {
    modules.frp = {
      instances = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "frp";

              role = lib.mkOption {
                type = lib.types.enum [
                  "server"
                  "client"
                ];
                description = ''
                  The frp consists of `client` and `server`. The server is usually
                  deployed on the machine with a public IP address, and
                  the client is usually deployed on the machine
                  where the Intranet service to be penetrated resides.
                '';
              };

              settings = lib.mkOption {
                type = settingsFormat.type;
                default = { };
                description = ''
                  Frp configuration, for configuration options
                  see the example of [client](https://github.com/fatedier/frp/blob/dev/conf/frpc_full_example.toml)
                  or [server](https://github.com/fatedier/frp/blob/dev/conf/frps_full_example.toml) on github.
                '';
                example = {
                  serverAddr = "x.x.x.x";
                  serverPort = 7000;
                };
              };
              configFile = lib.mkOption {
                type = lib.types.nullOr (lib.types.either lib.types.str lib.types.path);
                default = null;
                description = "Frp configuration file";
              };
            };
          }
        );
        default = { };
        description = ''
          Frp instances.
        '';
      };

      package = lib.mkPackageOption pkgs "frp" { };
    };
  };

  config = lib.mkIf (enabledInstances != { }) {
    assertions = lib.mapAttrsToList
    (instance: options:
      {
        assertion = !(options.enable && options.configFile != "" && options.configFile != null && options.settings != {});
        message = "when setting ${instance}, the value of configFile is ${options.configFile}, however the value of settings is ${lib.generators.toJSON {} options.settings}, and cause a conflict";
      }) enabledInstances
    ;
    systemd.services = lib.mapAttrs' (
      instance: options:
      let
        serviceName = "frp" + lib.optionalString (instance != "") ("-" + instance);
        configFile = if options.configFile != null then options.configFile else settingsFormat.generate "${serviceName}.toml" options.settings;
        isClient = (options.role == "client");
        isServer = (options.role == "server");
        serviceCapability = lib.optionals isServer [ "CAP_NET_BIND_SERVICE" ];
        executableFile = if isClient then "frpc" else "frps";
      in
      lib.nameValuePair serviceName {
        wants = lib.optionals isClient [ "network-online.target" ];
        after = if isClient then [ "network-online.target" ] else [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "A fast reverse proxy frp ${options.role} for instance ${instance}";
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 15;
          LoadCredential = [ ("frpc_${instance}.toml:" + configFile) ];
          ExecStart = "${cfg.package}/bin/${executableFile} --strict_config -c $\{CREDENTIALS_DIRECTORY}/frpc_${instance}.toml";
          StateDirectoryMode = lib.optionalString isServer "0700";
          DynamicUser = true;
          # Hardening
          UMask = lib.optionalString isServer "0007";
          CapabilityBoundingSet = serviceCapability;
          AmbientCapabilities = serviceCapability;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ] ++ lib.optionals isClient [ "AF_UNIX" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
        };
      }
    ) enabledInstances;
  };

  meta.maintainers = with lib.maintainers; [ zaldnoay ];
}

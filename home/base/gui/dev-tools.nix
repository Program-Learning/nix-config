{
  pkgs,
  lib,
  nur-DataEraserC,
  nix-jetbrains-plugins,
  ...
}:
let
  jetbrainsPluginList = {
    "common" = [
      "com.alibabacloud.intellij.cosy"
      "nix-idea"
    ];
    "idea-oss" = {
      "include" = [ ];
      "exclude" = [ ];
    };
    "idea" = {
      "include" = [ ];
      "exclude" = [ ];
    };
    "rust-rover" = {
      "include" = [ ];
      "exclude" = [ ];
    };
    "pycharm" = {
      "include" = [ ];
      "exclude" = [ ];
    };
    "goland" = {
      "include" = [ ];
      "exclude" = [ ];
    };
    "webstorm" = {
      "include" = [ ];
      "exclude" = [ ];
    };
    "clion" = {
      "include" = [ ];
      "exclude" = [ ];
    };
  };
  genJetbrainsPluginList =
    allPluginLists: packageName:
    let
      packageConfig =
        allPluginLists.${packageName} or {
          include = [ ];
          exclude = [ ];
        };
      combinedInclude = allPluginLists."common" ++ (packageConfig.include or [ ]);
      allPlugins = lib.unique combinedInclude; # 去重
      excluded = packageConfig.exclude or [ ];
      filteredPlugins = lib.filter (pluginId: !lib.elem pluginId excluded) allPlugins;
    in
    filteredPlugins;

  getMajorMinorVersion =
    version: builtins.concatStringsSep "." (lib.take 2 (lib.splitString "." version));
  jetbra = pkgs.fetchFromGitHub {
    owner = "LostAttractor";
    repo = "jetbra";
    rev = "94585581c360862eab1843bf7edd8082fdf22542";
    sha256 = "sha256-9jeiF9QS4MCogIowu43l7Bqf7dhs40+7KKZML/k1oWo=";
  };

  vmoptionsArray = [
    # NOTE: disable Wayland bcs ime not support well
    # "-Dawt.toolkit.name=WLToolkit"
    "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED"
    "--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED"
    "-javaagent:${nur-DataEraserC.packages.${pkgs.system}.ja-netfilter}/ja-netfilter.jar=jetbrains"
  ];
  vmoptions = builtins.concatStringsSep "\n" vmoptionsArray;
  # -javaagent:${jetbra}/ja-netfilter.jar=jetbrains
  # -javaagent:/home/nixos/Documents/.jetbra-free/static/ja-netfilter/ja-netfilter.jar=jetbrains
  postFixUpPatchFunction =
    productDir: vmoptionsFileName:
    old@{ postFixup, ... }:
    {
      postFixup = ''
        ${if postFixup != null then old.postFixup else ""}

        # add ja-netfilter
        cd $out/${productDir}
        echo '${vmoptions}' >> ${vmoptionsFileName}
      '';
    };
in
{
  home.packages =
    with pkgs;
    [
      dbeaver-bin # database manager
      # TODO: move tui network tools to a better place
      traceroute # trace route
      go-graft # proxy agent in terminal
      bettercap # mitm proxy tool
      whistle # HTTP, HTTP2, HTTPS, Websocket debugging proxy
      insomnia # REST client
      hoppscotch # Api Test Tool
      # ciscoPacketTracer8 # computer network tool
      # these is gns3, an alternative to packet tracer
      # gns3-server
      # gns3-gui
      linux-wifi-hotspot
      hostapd

      mitmproxy # http/https proxy tool
      wireshark # network analyzer

      # IDEs
      # jetbrains.idea-community

      # AI cli tools
      k8sgpt
      kubectl-ai # an ai helper opensourced by google

      mqttx
    ]
    ++ (lib.optionals pkgs.stdenv.isx86_64 [
      insomnia # REST client
    ])
    ++ (with nix-jetbrains-plugins.lib; [
      (buildIdeWithPlugins pkgs "idea-oss" (genJetbrainsPluginList jetbrainsPluginList "idea-oss"))

      (buildIdeWithPlugins pkgs "idea" (genJetbrainsPluginList jetbrainsPluginList "idea"))
      (buildIdeWithPlugins pkgs "rust-rover" (genJetbrainsPluginList jetbrainsPluginList "rust-rover"))
      (buildIdeWithPlugins pkgs "pycharm" (genJetbrainsPluginList jetbrainsPluginList "pycharm"))
      (buildIdeWithPlugins pkgs "goland" (genJetbrainsPluginList jetbrainsPluginList "goland"))
      (buildIdeWithPlugins pkgs "webstorm" (genJetbrainsPluginList jetbrainsPluginList "webstorm"))
      (buildIdeWithPlugins pkgs "clion" (genJetbrainsPluginList jetbrainsPluginList "clion"))

      # (jetbrains.idea.overrideAttrs {vmopts = vmoptions;})
      # (jetbrains.rust-rover.overrideAttrs {vmopts = vmoptions;})
      # (jetbrains.pycharm.overrideAttrs {vmopts = vmoptions;})
      # (jetbrains.goland.overrideAttrs {vmopts = vmoptions;})
      # (jetbrains.webstorm.overrideAttrs {vmopts = vmoptions;})
      # (jetbrains.clion.overrideAttrs {vmopts = vmoptions;})

      # (jetbrains.idea.overrideAttrs
      # (postFixUpPatchFunction "idea/bin" "idea64.vmoptions"))
      # (jetbrains.rust-rover.overrideAttrs
      #   (postFixUpPatchFunction "rust-rover/bin" "rustrover64.vmoptions"))
      # (jetbrains.pycharm.overrideAttrs
      #   (postFixUpPatchFunction "pycharm/bin" "pycharm64.vmoptions"))
      # (jetbrains.goland.overrideAttrs
      #   (postFixUpPatchFunction "goland/bin" "goland64.vmoptions"))
      # (jetbrains.webstorm.overrideAttrs
      #   (postFixUpPatchFunction "webstorm/bin" "webstorm64.vmoptions"))
      # (jetbrains.clion.overrideAttrs
      #   (postFixUpPatchFunction "clion/bin" "clion64.vmoptions"))
      # eclipses.eclipse-sdk
      # eclipses.eclipse-jee
    ]);
  xdg.configFile."JetBrains/IntelliJIdea${getMajorMinorVersion pkgs.jetbrains.idea.version}/idea64.vmoptions".text =
    vmoptions;
  xdg.configFile."JetBrains/PyCharm${getMajorMinorVersion pkgs.jetbrains.pycharm.version}/pycharm64.vmoptions".text =
    vmoptions;
  xdg.configFile."JetBrains/CLion${getMajorMinorVersion pkgs.jetbrains.clion.version}/clion64.vmoptions".text =
    vmoptions;
  xdg.configFile."JetBrains/RustRover${getMajorMinorVersion pkgs.jetbrains.rust-rover.version}/rustrover64.vmoptions".text =
    vmoptions;
  xdg.configFile."JetBrains/GoLand${getMajorMinorVersion pkgs.jetbrains.goland.version}/goland64.vmoptions".text =
    vmoptions;
  xdg.configFile."JetBrains/WebStorm${getMajorMinorVersion pkgs.jetbrains.webstorm.version}/webstorm64.vmoptions".text =
    vmoptions;
}

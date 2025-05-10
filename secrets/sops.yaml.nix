# To update .sops.yaml:
# $ inv update-sops-files
let
  mapAttrsToList = f: attrs:
    map (name: f name attrs.${name}) (builtins.attrNames attrs);

  renderPermissions = (attrs: mapAttrsToList
    (path: keys: {
      path_regex = path;
      key_groups = [{
        age = keys ++ groups.admin;
      }];
    })
    attrs);

  # command to add a new age key for a new host
  # inv print-age-key --hosts "host1,host2"
  keys = builtins.fromJSON (builtins.readFile ./pubkeys.json);
  groups = with keys.users; {
    admin = [
      # admins may access all secrets
      DEC
    ];
    all = builtins.attrValues (keys.users // keys.machines);
  };

  # This is the list of permissions per file. The admin group has permissions
  # for all files. Amy.yml additionally can be decrytped by amy.
  # spec device use this
  sopsPermissions = builtins.listToAttrs (mapAttrsToList (hostname: key: { name = "sops/hosts/${hostname}.yml$"; value = [ key ]; }) keys.machines) //
    {
      # all devices use this
      "sops/modules/secrets.yml$" = groups.all;
    } //
    builtins.mapAttrs (name: value: (map (x: keys.machines.${x}) value)) {
      # spec device array use this
      "sops/modules/nfs/secrets.yml$" = [ "idols-ai" ];
      "sops/modules/k3s/secrets.yml$" = [ "idols-ai" ];
    };

in
{
  creation_rules = [
    # example: 
    #{
    #  path_regex = "foobar.yaml$";
    #  key_groups = [
    #    {age = groups.admin ++ [
    #      "key3"
    #    ];}
    #  ];
    #}
  ] ++ (renderPermissions sopsPermissions);
}

{
  lib,
  outputs,
}:
lib.genAttrs
(builtins.attrNames outputs.nixOnDroidConfigurations)
(
  name: outputs.nixOnDroidConfigurations.${name}.config.user.userName
)

_: (_: super: {
  # temporarily fix bug of pkgs.bwraps do not exist
  bwraps = {
    wechat = super.callPackage ../../hardening/bwraps/wechat.nix {};
  };
})

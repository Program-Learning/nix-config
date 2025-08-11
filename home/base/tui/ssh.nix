{
  config,
  mysecrets,
  ...
}:
{
  home.file.".ssh/romantic.pub".source = "${mysecrets}/public/romantic.pub";
  home.file.".ssh/gluttony.pub".source = "${mysecrets}/public/gluttony.pub";
  home.file.".ssh/juliet-age.pub".source = "${mysecrets}/public/juliet-age.pub";
  home.file.".ssh/y9000k2021h_id_rsa.pub".source = "${mysecrets}/public/y9000k2021h_id_rsa.pub";
  home.file.".ssh/y9000k2021h_id_ed25519.pub".source =
    "${mysecrets}/public/y9000k2021h_id_ed25519.pub";

  programs.ssh = {
    enable = true;

    # "a private key that is used during authentication will be added to ssh-agent if it is running"
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        # "Using SSH over the HTTPS port for GitHub"
        # "(port 22 is banned by some proxies / firewalls)"
        hostname = "ssh.github.com";
        port = 443;
        user = "git";

        # Specifies that ssh should only use the identity file explicitly configured above
        # required to prevent sending default identity files first.
        identitiesOnly = true;
      };

      "192.168.*" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "romantic holds my homelab~"
        identityFile = "/etc/agenix/y9000k2021h_id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}


{pkgs, ...}: 
{
  # MacOS specific configuration
  home.packages = with pkgs; [

  ];

  programs.ssh = {
    enable = true;

    # all my ssh private key are generated by `ssh-keygen -t ed25519 -C "ryan@nickname"`
    # the config's format:
    #   Host —  given the pattern used to match against the host name given on the command line.
    #   HostName — specify nickname or abbreviation for host
    #   IdentityFile — the location of your SSH key authentication file for the account.
    # format in details:
    #   https://www.ssh.com/academy/ssh/config
    extraConfig = ''
      Host 192.168.*
        # allow to securely use local SSH agent to authenticate on the remote machine.
        # It has the same effect as adding cli option `ssh -A user@host`
        ForwardAgent yes
        # romantic holds my homelab~
        IdentityFile ~/.ssh/romantic
        # Specifies that ssh should only use the identity file explicitly configured above
        # required to prevent sending default identity files first.
        IdentitiesOnly yes

      Host github.com
        Hostname github.com
        # github is controlled by gluttony~
        IdentityFile ~/.ssh/harmonica
        # Specifies that ssh should only use the identity file explicitly configured above
        # required to prevent sending default identity files first.
        IdentitiesOnly yes
    '';

    # use ssh-agent so we only need to input passphrase once
    # run `ssh-add /path/to/key` for every identity file
    # check imported keys by `ssh-add -l`
    # TODO `ssh-add` can only add keys temporary, use gnome-keyring to unlock all keys after login.
  };
}

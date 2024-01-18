{
  username,
  userfullname,
  nuenv,
  ...
} @ args: {
  nixpkgs.overlays =
    [
      nuenv.overlays.default
    ]
    ++ (import ../overlays args);

  users.users.${username} = {
    description = userfullname;
    openssh.authorizedKeys.keys = [
      # nix-on-droid_mondrian_1
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPj89CeLdjkz7bj5j0u+wlHHu5e0hKQIQl36rthhpW+K nix-on-droid@localhost"
      # nixos_y9000k2021h_1
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO0+WOKwK9EcRj2Bcdt/VpiB9MvZYqk4JKxlcQElskx nixos@nixos"
      # Termux_mondrian_1
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM8clFtvkMoMNzhisRRv3QAihIRO2FLY+QqZ1YJ1o0JM BlankTreeRootFileSystem@outlook.com"
      # Termux_pstar_1
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDD9oj03QzeGTx7l3XEcIt/rDD6UwarjxeV38iVa8FKQftwuhFVqeJpI+kAeWwUynTOhKLCG/WbcLNCFGI9I9E3NjkSPMXv018yy7X30VFcEn7Arl7Ab48ZVEgRguru5XpuZZWI+IID4T5erbsng1ekQGLBgz0hEokGOKhyqoTgUb/Fpm5S6Ubl66//OF5OIkcdmKQ8mRtQxrjxqYB3ZWX4xbxevKHQbGFtbjZVWO70GfGnMfl6urpPMVmJXe+tHarDsQAiU9BySO+7kmkRfQfUtwiOJ7o2M0evIcKuxyzQ5yRSO9ZeHMzjDLaGAK/5UMvoEP7yZfrom0qBfQpEeHnvEUct80tugH0xCvmqMq1SKxaG64LsRXJIFsv71vPHvLU/U1PTYEEuSVOg+coGG/hMl/iuq9bdfuiiyDjNZtn6FpY5fDj6lBF49wqQuc7JMQ4pWH88aRqCFLlRXDk/jTe+BuaEfghOgbCpq1Xyrb3cnc9iR88udXzas18SqcAT9ec= 102341238+DataEraserC@users.noreply.github.com"
      # nixos_y9000k2021h_1
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEIdxYFQnQuvMttMJcXIPxDRn1OhbirLIxfELoDPI0RKjub1nowOM+mo9QGatPUFBf2OcMKHYES9h5mYUyf243Nyykef9RneBKB6fzfk+k6UQRwpuGObM4ZXVUSVG6g1vsdvb7TbXkFGtwSsOZliuiO12XLg4x26DRuVNJsHpsLdTY5cwLH4w/pcjm/TAIjBNTd37ziaVReQsp2t9zPIkuMH5FwKaBUUXgIy47DCTYOpaEzfanzFe4+EP7BDo4Ch3KviAeAVub1WluwvByXNSgUT7fZC7b0ru8uQyovHNlUXJpMSI1ccXj7DRLWJbsfDD2/h/vv8ErTWVxHZ/am9fqkvgjD7FgrD543u39TtppZzEV3pWlZfemy5uWi9BjnNcx10yIC3Gt9ixgx6jiLjHH25zgQheecVrBB9ggtKX3dnwbhR3ItOA7MhimABeinkXAXhpinwlKzjapRUiNxcNXp9LjzcXkHyd/GNYk9gCiqb7sdsUNbWsSbrNEhyMBhMk= nixos@nixos"
    ];
  };

  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = [username];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://nix-community.cachix.org"
      # my own cache server
      "https://ryan4yin.cachix.org"
      "https://program-learning.cachix.org"
      "https://ai.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ryan4yin.cachix.org-1:Gbk27ZU5AYpGS9i3ssoLlwdvMIh0NxG0w8it/cv9kbU="
      "program-learning.cachix.org-1:Pfl2r+J5L9wJqpDnop6iQbrR3/Ts4AUyotu89INRlSU="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    builders-use-substitutes = true;
  };
}

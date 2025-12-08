# https://github.com/Seanwanq/nix-config/blob/545b69d896b86749fe26a8ff4af8a66240cdde88/modules/tpm-luks.nix
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # TPM 2.0 自动解锁 LUKS 加密磁盘
  # 这样开机时不需要输入密码，只在登录时输入密码

  # 启用 TPM 2.0 支持
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true; # PKCS#11 支持（可选）
    tctiEnvironment.enable = true; # 设置 TCTI 环境变量
  };

  # 安装 TPM 管理工具
  environment.systemPackages = with pkgs; [
    tpm2-tools # TPM 2.0 命令行工具
    tpm2-tss # TPM 2.0 软件栈
  ];

  # 启用 systemd-cryptenroll 用于 TPM 自动解锁
  boot.initrd.systemd = {
    enable = true;
    # 在 initrd 阶段启用 TPM 支持
    tpm2.enable = true;
  };

  # 配置 LUKS 设备使用 TPM 解锁
  # 注意：这个配置在 TPM 注册完成后才会生效
  # 首次需要手动注册（见下方说明）
}

rec {
  # user information
    username = "nixos";
    userfullname = "DataEraserC";
    useremail = "102341238+DataEraserC@users.noreply.github.com";

  # linux systems
  x64_system = "x86_64-linux";
  riscv64_system = "riscv64-linux";
  aarch64_system = "aarch64-linux";
  # darwin systems
  x64_darwin = "x86_64-darwin";
  aarch64_darwin = "aarch64-darwin";
  allSystems = [x64_system riscv64_system aarch64_system x64_darwin aarch64_darwin];
}

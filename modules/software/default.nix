{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./network.nix
    ./packages.nix
    ./system.nix
    ../../settings/users.nix
    ./virt.nix
    ./theme.nix
    ./services.nix
    ./windows
    ./packages/rust.nix
    ./ld.nix
  ];
}

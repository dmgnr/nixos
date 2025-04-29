{ lib, pkgs, ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.waydroid.enable = true;

  systemd.services."docker" = {
    overrideStrategy = "asDropin";
    unitConfig.After = lib.mkForce "docker.socket firewalld.service containerd.service time-set.target";
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    wineWowPackages.full
    distrobox
  ];

  boot.binfmt.emulatedSystems = [
    "wasm32-wasi"
    "x86_64-windows"
    "aarch64-linux"
  ];
}

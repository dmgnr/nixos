{
  networking.hostName = "nyx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  # networking.wireless.iwd.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";

  # Networking
  services.tailscale.enable = true;
  # "100.100.100.100" "45.90.28.164" "45.90.30.164"
  networking.nameservers = [
    "45.90.28.164"
    "1.1.1.1"
    "45.90.30.164"
    "8.8.8.8"
  ];
  networking.search = [
    "tail71b97a.ts.net"
    "dgnr.us"
  ];
  networking.firewall.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.avahi = {
    nssmdns4 = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  services.openvpn.servers = {
    default = {
      config = ''config /etc/nixos/settings/profile.ovpn '';
      autoStart = true;
    };
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "hyprland";
}

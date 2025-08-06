{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # Micro:bit WebUSB support
  services.udev.packages = with pkgs; [
    platformio-core
    openocd
  ];
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", MODE="0664",
    GROUP="plugdev"
  '';
}

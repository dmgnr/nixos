{
  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
      priority = 1;
    }
  ];

  hardware.ksm.enable = true;
}

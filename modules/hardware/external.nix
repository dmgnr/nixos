{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.logind.powerKey = "ignore";
  services.logind.lidSwitch = "suspend";
  systemd.sleep.extraConfig = "SuspendState=mem";

  powerManagement.powertop.enable = true;
}

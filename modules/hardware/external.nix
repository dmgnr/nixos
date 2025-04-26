{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.logind.powerKey = "ignore";
  systemd.sleep.extraConfig = "SuspendState=mem";
}

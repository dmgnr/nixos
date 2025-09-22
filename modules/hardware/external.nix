{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend";
  };
  systemd.sleep.extraConfig = "SuspendState=mem";

  powerManagement.powertop.enable = true;

  # Location service
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  # USB Automounting
  services.gvfs.enable = true;

  # Phone webcam mirroring
  programs.droidcam.enable = true;
  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=2,3 width=640,1920 max_width=1920 height=480,1080 max_height=1080 format=YU12,YU12 exclusive_caps=1,1 card_label=Phone
  '';
}

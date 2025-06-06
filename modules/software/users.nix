{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dgnr = {
    isNormalUser = true;
    description = "Dreamgineer";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kdeconnect-kde
      git
      vesktop
      fastfetch
      nixd
      nixfmt-rfc-style
      element-desktop
      blackbox-terminal
      gh
      spotube
      inshellisense
      gearlever
      appimage-run
      nvtopPackages.full
      scrcpy

      godns
      #  thunderbird
    ];
  };
  users.users.silas = {
    isNormalUser = true;
    description = "SupremeFlyGuy";
    extraGroups = [
      "networkmanager"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  security.pam.services.hyprlock = { };

  nix.settings.trusted-users = [
    "root"
    "dgnr"
  ];
}

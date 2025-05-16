{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    vscode
    plymouth
    bun
    zulu23
    zulu17 # For WPILib, should still default to 23 in global
    ntfs3g
    kdePackages.qtdeclarative
    ktailctl
    nodejs_20
    tpm2-tss
    where-is-my-sddm-theme
    (sddm-astronaut.override { embeddedTheme = "blackhole"; })
    kdePackages.qtmultimedia
    playerctl
    wl-clipboard
    system76-power
    bibata-cursors
    adwaita-qt
    adwaita-qt6
    xdg-desktop-portal-gtk
    libsecret
  ];

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.Anuken.Mindustry"
      "com.github.cubitect.cubiomes-viewer"
      "com.modrinth.ModrinthApp"
      "it.mijorus.gearlever"
      "org.unofficialrevport.REVHubInterface"
      "org.vinegarhq.Sober"
      "uk.co.powdertoy.tpt"
      "com.obsproject.Studio"
      "org.speedcrunch.SpeedCrunch"
    ];
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default value
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = ./../..;
  };

  programs.mtr.enable = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/uri-list" = "thorium-browser.desktop";
    };
  };
}

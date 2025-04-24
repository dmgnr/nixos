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
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
  ];

  services.flatpak.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = builtins.toString ./.;
  };

  programs.mtr.enable = true;
}

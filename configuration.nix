# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Limit nix rebuilds priority.  When left on the default is uses all available reouses which can make the system unusable
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
      ];
    };
  };

  time.timeZone = lib.mkDefault "Asia/Bangkok";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber.enable = true;
    wireplumber.extraConfig."99-stop-microphone-auto-adjust" = {
      "access.rules" = [
        {
          matches = [ { "application.process.binary" = "electron"; } ];
          actions = {
            update-props = {
              default_permissions = "rx";
            };
          };
        }
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.logind.powerKey = "ignore";
  services.logind.lidSwitch = "suspend";
  systemd.sleep.extraConfig = "SuspendState=mem";

  powerManagement.powertop.enable = true;

  # Location service
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  # USB Automounting
  services.gvfs.enable = true;

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
    nodejs_20
    spotify

    python312Full
    astyle
    vesktop
    sbctl
    firefox
    comma

    tpm2-tss
    (callPackage ./thorium/thorium.nix { })
  ];

  # Let's be more pragmatic and try to run binaries sometimes
  # at the cost of sweeping bugs under the rug.
  programs.nix-ld = {
    enable = true;
    # put whatever libraries you think you might need
    # nix-ld includes a strong sane-default as well
    # in addition to these
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      xorg.libX11.out
      xorg.libXext.out
      xorg.libXi.out
      xorg.libXrender.out
      xorg.libXtst.out
      libGL
    ];
  };

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dgnr";
  services.xserver.enable = false;
  programs.xwayland.enable = true;

  services.openvpn.servers = {
    ctf = {
      config = ''config /etc/nixos/ctf.conf '';
    };
  };

  boot = {
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = with pkgs; [
        # By default we would install all themes
        nixos-bgrt-plymouth
      ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=2"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Use XanMod kernel
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader = {
      # systemd-boot.enable = true;

      # Lanzaboote override systemd-boot
      systemd-boot.enable = true;

      timeout = 0;
    };
    kernel.sysctl = {
      "vm.swappiness" = 20;
    };
    initrd.systemd.enable = true;

    supportedFilesystems = [ "ntfs" ];
  };

  users.users.dgnr = {
    isNormalUser = true;
    description = "Dreamgineer";
    extraGroups = [
      "networkmanager"
      "plugdev"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      git
      vesktop
      fastfetch
      nixd
      nixfmt-rfc-style
      gh
      spotube
      inshellisense
      gearlever
      appimage-run
      nvtopPackages.full
      scrcpy
      #  thunderbird
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  security.pam.services.hyprlock = { };

  nix.settings.trusted-users = [
    "root"
    "dgnr"
  ];
  networking.hostName = "nyx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
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

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    prime = {
      reverseSync.enable = true;
      # Enable if using an external GPU
      allowExternalGpu = false;

      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:0:2:0";
      # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
    };

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
      priority = 1;
    }
  ];

  hardware.ksm.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

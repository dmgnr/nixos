{
  services = {
    gnome.gnome-keyring.enable = true;
    spotifyd = {
      enable = true;
      settings = {
        global = {
          use_mpris = true;
        };
      };
    };
  };
  security.pam.services.sddm.enableGnomeKeyring = true;
}

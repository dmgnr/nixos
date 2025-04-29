{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  programs.nix-init.enable = true;
}

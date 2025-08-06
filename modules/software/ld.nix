# https://fzakaria.com/2025/02/26/nix-pragmatism-nix-ld-and-envfs
{ pkgs, ... }:
{
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

  services.envfs.enable = true;
}

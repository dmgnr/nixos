{ ... }:
{
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      completions.algorithm = "fuzzy";
    };
    configFile.source = ./assets/init.nu;
    extraEnv = ''
      $env.PROMPT_COMMAND_RIGHT = ""
      $env.PROMPT_INDICATOR = " "
      $env.SHELL = "nu"
      $env.NH_FLAKE = "/etc/nixos"
      $env.TRANSIENT_PROMPT_COMMAND = " "
      $env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
    '';
    shellAliases = {
      a = "nix-alien";
      frccode = "distrobox enter -n ubuntu -r -- bash /home/dgnr/wpilib/2025/frccode/frccode2025";
      profile = "system76-power profile";
    };
  };

  # Manually enabled in init.nu
  programs.pay-respects.enableNushellIntegration = false;

  # Carapace
  programs.carapace.enable = true;

  # Direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
    silent = true;
  };
}

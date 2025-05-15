{ config, ... }:
let
  curve = "64 68 72 75 79 82 86 90";
in
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelModules = [ "acpi_call" ];
  };
  systemd.services.afc = {
    description = "ASUS Fan Curve";
    script = "${./fan/afc.sh} ${curve}";
    wantedBy = [ "multi-user.target" ];
  };
}

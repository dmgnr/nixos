{ pkgs, ... }:
{
  networking.proxy.default = "http://localhost:1080";
  environment.systemPackages = [ pkgs.juicity ];
  systemd.services.juicity = {
    enable = true;
    after = [
      "network.target"
      "nss-lookup.target"
    ];
    serviceConfig = {
      DynamicUser = "yes";
      Type = "simple";
      CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW";
      AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW";
      ExecStart = "${pkgs.juicity}/bin/juicity-client run -c ${./client.json} --disable-timestamp";
      Restart = "on-failure";
      LimitNPROC = 512;
      LimitNOFILE = "infinity";
    };
  };
}

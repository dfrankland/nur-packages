{ config, lib, pkgs, ... }:

with lib;

{
  options.services.pritunl-client-daemon.enable = mkOption {
    type = types.bool;
    default = false;
    description = ''
      This option enables Pritunl client daemon.
    '';
  };

  config =
    let
      cfg = config.services.pritunl-client-daemon;
    in
    mkIf cfg.enable {
      systemd.services.pritunl-client-daemon = {
        description = "Pritunl Client Daemon";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network.target" ];
        after = [
          "network-online.target"
          "NetworkManager.service"
          "systemd-resolved.service"
        ];
        startLimitBurst = 5;
        startLimitIntervalSec = 20;
        serviceConfig = {
          ExecStart = "${pkgs.pritunl-client}/bin/pritunl-client daemon --foreground";
          Restart = "always";
          RestartSec = 1;
        };
      };
    };
}

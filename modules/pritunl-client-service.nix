{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pritunl-client-service;
in
{
  options = {
    services.pritunl-client-service = {
      enable = mkEnableOption "Pritunl Client Daemon";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pritunl-client-service = {
      description = "Pritunl Client Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.pritunl-client-service}/bin/pritunl-client-service";
      };
    };
  };
}

{ buildGoModule, pritunl-client-service }:

buildGoModule rec {
  pname = "pritunl-client";

  version = pritunl-client-service.version;

  src = pritunl-client-service.src;

  vendorSha256 = pritunl-client-service.vendorSha256;

  subPackages = [ "cli" ];

  postInstall = ''
    mv $out/bin/cli $out/bin/${pname}
  '';

  meta = pritunl-client-service.meta;
}

{ lib, buildGoModule, fetchFromGitHub, makeWrapper, nettools, iptables, openvpn, openresolv, wireguard-tools, iproute2, systemd, coreutils, util-linux }:

buildGoModule rec {
  pname = "pritunl-client-service";

  version = "1.2.3019.52";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-client-electron";

    # TODO: Switch to using `version` above when the next version, which
    # includes the `go.mod` file, is published.
    rev = "7682a795a61c4f2485353d0978d2a8c85a7ac436";

    sha256 = "sha256-KT7EqTkQIziWXwlzfKhtnbZd1B1+oWUwKIudkIgyHCI=";
  };

  vendorSha256 = "sha256-BeoHaQ9mkO1g9rRT0Z1zjb4nMUZPOZMArtJphl4Mkd0=";

  subPackages = [ "service" ];

  buildInputs = [
    makeWrapper
  ];

  postInstall = ''
    mv $out/bin/service $out/bin/${pname}
    wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [
      nettools
      iptables
      openvpn
      openresolv
      wireguard-tools
      iproute2
      systemd
      coreutils
      util-linux
    ]}
  '';

  meta = {
    homepage = "https://github.com/pritunl/pritunl-client-electron";
    description = "Pritunl OpenVPN client";
  };
}

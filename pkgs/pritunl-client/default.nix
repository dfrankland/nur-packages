{ lib, fetchFromGitHub, python27Packages }:

python27Packages.buildPythonApplication rec {
  pname = "pritunl-client";
  version = "1.0.1865.25";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-client";
    rev = version;
    sha256 = "sha256-b6Ynl/UQK3M+t1uEle6z9m8aRouhmCNdZxTdkzHposk=";
  };

  propagatedBuildInputs = [ python27Packages.requests ];

  meta = with lib; {
    description = "Pritunl VPN Client";
    license = licenses.unfree;
    homepage = "https://client.pritunl.com/";
    platforms = platforms.all;
  };
}

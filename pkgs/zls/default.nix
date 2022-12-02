{ fetchFromGitHub, zigpkgs, known-folders, lib, stdenvNoCC }:

with lib;

let
  name = "zls";
  version = "0.10.0";
in
stdenvNoCC.mkDerivation {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = name;
    rev = version;
    sha256 = "sha256-M0GG4KIMcHN+bEprUv6ISZkWNvWN12S9vqSKP+DRU9M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zigpkgs."0.10.0" ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    mkdir -p $out
    zig build install -Dcpu=baseline -Ddata_version=master -Dknown-folders=${known-folders}/known-folders.zig --prefix $out
  '';

  meta = {
    description = "Zig LSP implementation + Zig Language Server";
    homepage = "https://zigtools.github.io/install-zls/";
    license = licenses.mit;
  };
}

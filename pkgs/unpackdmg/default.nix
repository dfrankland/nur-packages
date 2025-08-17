{ lib, stdenv, _7zz, makeWrapper }:

stdenv.mkDerivation {
  pname = "unpackdmg";
  version = "0.0.1";
  src = ./.;

  buildInputs = [ _7zz ];
  nativeBuildInputs = [ makeWrapper ];

  setupHook = ./setup-hook.sh;

  installPhase = ''
    mkdir -p $out/bin
    cp ./unpackdmg.sh $out/bin/unpackdmg
    wrapProgram $out/bin/unpackdmg --prefix PATH : ${lib.makeBinPath [ _7zz ]}
  '';
}

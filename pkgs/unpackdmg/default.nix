{ lib, stdenv, _7zz, makeWrapper }:

let
  # Adapted from
  # https://github.com/jacekszymanski/nixcasks/blob/b1dbcbabb04bfb434002eaee687ada37bfab0051/7zip/default.nix
  sevenzip = _7zz.overrideAttrs (finalAttrs: previousAttrs: {
    # NOTE: 7zip files use CRLF end of line sequences, but the diff files use LF. Ensure ONLY the
    # content of the diff files use CRLF.
    #
    # Just save yourself the heartache and use git for this.
    patches = previousAttrs.patches ++ [ ./dangerous-links.patch ];
  });
in
stdenv.mkDerivation {
  pname = "unpackdmg";
  version = "0.0.1";
  src = ./.;

  buildInputs = [ sevenzip ];
  nativeBuildInputs = [ makeWrapper ];

  setupHook = ./setup-hook.sh;

  installPhase = ''
    mkdir -p $out/bin
    cp ./unpackdmg.sh $out/bin/unpackdmg
    wrapProgram $out/bin/unpackdmg --prefix PATH : ${lib.makeBinPath [ sevenzip ]}
  '';
}

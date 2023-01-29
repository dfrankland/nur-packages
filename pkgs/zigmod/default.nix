{ fetchFromGitHub, zigpkgs, git, cacert, lib, stdenv, autoPatchelfHook }:

with lib;

let
  name = "zigmod";
  version = "r84";
in
stdenv.mkDerivation {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "nektro";
    repo = name;
    rev = version;
    sha256 = "sha256-7BBuZrK8XmGhD20H7yK5tBXNoxvtk6/kylzrwnE6nYo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    zigpkgs."master-2022-11-16"
    git
    cacert
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    mkdir -p $out
    zig build install -Drelease -Dcpu=baseline --prefix $out
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash =
    if (stdenv.isLinux)
    then "sha256-9BKuGkeSXsA7IbBbV7wV11pGIrf/7CJfEooQAApmS/k="
    else "sha256-an1HuIQAtq1QiisGw13R0bHtdt464PBN/OVoJGCv8BY=";

  meta = {
    description = "A package manager for the Zig programming language.";
    homepage = "https://aquila.red/";
    license = licenses.mit;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
      "x86_64-windows"
    ];
  };
}

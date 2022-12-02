{ fetchFromGitHub, zigpkgs, git, cacert, lib, stdenvNoCC }:

with lib;

let
  name = "zigmod";
  version = "r84";
in
stdenvNoCC.mkDerivation {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "nektro";
    repo = name;
    rev = version;
    sha256 = "sha256-7BBuZrK8XmGhD20H7yK5tBXNoxvtk6/kylzrwnE6nYo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zigpkgs."master-2022-11-16" git cacert ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    mkdir -p $out
    zig build install -Dcpu=baseline --prefix $out
  '';

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

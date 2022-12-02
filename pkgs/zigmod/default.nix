{ fetchFromGitHub, zigpkgs, git, cacert, lib, stdenvNoCC }:

with lib;

let
  version = "r84";
in
stdenvNoCC.mkDerivation {
  pname = "zigmod";
  inherit version;

  src = fetchFromGitHub {
    owner = "nektro";
    repo = "zigmod";
    fetchSubmodules = true;
    rev = version;
    sha256 = "sha256-7BBuZrK8XmGhD20H7yK5tBXNoxvtk6/kylzrwnE6nYo=";
  };

  nativeBuildInputs = [ zigpkgs."master-2022-11-16" git cacert ];

  installPhase = ''
    mkdir -p $out
    zig build install -Dcpu=baseline --prefix $out
  '';

  XDG_CACHE_HOME = ".cache";

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

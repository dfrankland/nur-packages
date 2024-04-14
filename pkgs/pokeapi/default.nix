{ pkgs, lib, fetchFromGitHub, python3Packages, python3, pythonManylinuxPackages, autoPatchelfHook }:

let
  mach-nix-src = builtins.fetchTarball {
    name = "mach-nix";
    url = "https://github.com/DavHau/mach-nix/archive/refs/tags/3.5.0.tar.gz";
    sha256 = "sha256:185qf6d5xg8qk1hb1y0b5gggr71vdz8v9d5ga4zg7dmcb1aypxcg";
  };
  mach-nix = import mach-nix-src { inherit pkgs; };
  pname = "pokeapi";
  version = "2.7.0";
  src = fetchFromGitHub {
    owner = "PokeAPI";
    repo = pname;
    rev = version;
    sha256 = "sha256-JLP6yUW47WA8t/IPa2V/axcV18nyzuG2h8AXpmc5ScY=";
  };
in
mach-nix.buildPythonApplication rec {
  inherit pname version src;

  requirements = builtins.readFile "${src}/requirements.txt";

  meta = {
    description = "The Pokémon API";
    license = lib.licenses.bsd3;
    homepage = "https://pokeapi.co";
    platforms = lib.platforms.unix;
  };
}

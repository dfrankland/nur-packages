{ lib, stdenv, fetchFromGitHub, fetchpatch, fetchsvn, fetchurl, gcc, flex, bison, boost, texinfo, zlib }:

let
  gbdk-2020-sdcc = stdenv.mkDerivation rec {
    pname = "gbdk-2020-sdcc";
    version = "14228";

    src = fetchsvn {
      url = "svn://svn.code.sf.net/p/sdcc/code/trunk";
      rev = version;
      sha256 = "sha256-HdaZhzlJpE2VJyAtSHYJO2s+vtsLmVHaJq3cC3F4KnE=";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/gbdk-2020/gbdk-2020-sdcc/releases/download/patches/gbdk-4.2-nes_banked_nonbanked_v4_combined.diff.patch";
        # NOTE: This hash must be updated after changes to options like `decode`.
        sha256 = "sha256-ecPXFofYi/IWrNxN+eg4RcgGHvODXo2LfKNHctImkJM=";
        decode = "sed 's/.\\/..\\/sdcc-14228_clean//g'";
      })
    ];

    nativeBuildInputs = [ flex bison boost texinfo zlib ];

    buildPhase = ''
      cd ./sdcc
      ./configure CXXFLAGS="$(CXXFLAGS) -Wno-format-security" --disable-shared --enable-gbz80-port  --enable-z80-port  --enable-mos6502-port  --enable-mos65c02-port  --disable-mcs51-port  --disable-z180-port  --disable-r2k-port  --disable-r2ka-port  --disable-r3ka-port  --disable-tlcs90-port  --disable-ez80_z80-port  --disable-z80n-port  --disable-ds390-port  --disable-ds400-port  --disable-pic14-port  --disable-pic16-port  --disable-hc08-port  --disable-s08-port  --disable-stm8-port  --disable-pdk13-port  --disable-pdk14-port  --disable-pdk15-port  --disable-ucsim  --disable-doc  --disable-device-lib
      make
    '';

    installPhase = ''
      # New sdcc build no longer copies some binaries to bin
      cp -f src/sdcc bin
      cp -f support/sdbinutils/binutils/sdar bin
      cp -f support/sdbinutils/binutils/sdranlib bin
      cp -f support/sdbinutils/binutils/sdobjcopy bin
      cp -f support/sdbinutils/binutils/sdnm bin
      cp -f support/cpp/gcc/cc1 bin
      cp -f support/cpp/gcc/cpp bin/sdcpp
      strip bin/* || true
      # remove .in mapping files, etc
      rm -f bin/*.in
      rm -f bin/Makefile
      rm -f bin/README
      # Move cc1 to it's special hardwired path
      mkdir libexec
      mkdir libexec/sdcc
      ${(if (stdenv.isDarwin) then ''
        # Special case - use sdcc official build of cc1 since it has static linkage for libisl, libzstd (had some trouble with that on this build)
        # this will untar into libexec/sdcc/cc1
        cp ${(fetchurl {
          url = "https://github.com/gbdk-2020/gbdk-2020-sdcc/releases/download/sdcc-extras/sdcc-4.3-macos-cc1-14110.tar.gz";
          sha256 = "sha256-bVrKXjSwzxpxMsdmWkRZXIwbK6ysXNoV1gmo6c65QsI=";
        })} macos-cc1.tar.gz
        tar xvfz macos-cc1.tar.gz
      '' else ''
        mv bin/cc1 libexec/sdcc
      '')}

      mkdir -p $out
      cp -r bin $out/
      cp -r libexec $out/
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "gbdk-2020";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "gbdk-2020";
    repo = "gbdk-2020";
    rev = "74b5d95c42ecbc73ff29260f67918eea876badf7";
    sha256 = "sha256-2cv+P4+HR5lWvMCbhtLXcF9tXmsQRm2s+xtztl/9tCw=";
    deepClone = true;
  };

  nativeBuildInputs = [ gbdk-2020-sdcc gcc ];
  buildInputs = [ gbdk-2020-sdcc ];

  SDCCDIR = gbdk-2020-sdcc;

  installPhase = ''
    mkdir -p $out
    cp -r build/gbdk/* $out/
  '';

  meta = with lib; {
    description = "An updated version of GBDK, A C compiler, assembler, linker and set of libraries for the Z80 like Nintendo Gameboy.";

    longDescription = "GBDK is a cross-platform development kit for sm83 and z80 based gaming consoles. It includes libraries, toolchain utilities and the SDCC C compiler suite.";

    homepage = "https://gbdk-2020.github.io/gbdk-2020/";
    license = lib.licenses.gpl2;

    platforms = platforms.all;
  };
}

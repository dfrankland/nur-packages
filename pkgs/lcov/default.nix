{ lib, stdenv, fetchFromGitHub, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lcov";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "linux-test-project";
    repo = "lcov";
    rev = "v${version}";
    sha256 = "sha256-LRvSDuCvOCT5/fReSLK8ABc9np7mWJFK81uJtp9E/XY=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  preBuild = ''
    patchShebangs bin/
    makeFlagsArray=(PREFIX=$out LCOV_PERL_PATH=$(command -v perl))
  '';

  postInstall = with perlPackages; ''
    wrapProgram $out/bin/lcov --set PERL5LIB ${makeFullPerlPath [
      # List of dependencies needed
      # https://github.com/linux-test-project/lcov/blob/v2.0/README#L86-L106
      CaptureTiny
      DateTime
      # Devel::Cover (only needed for development)
      # Digest::MD5 (standard module of Perl)
      # File::Spec (standard module of Perl)
      JSON
      # Memory::Process (not required, used to control memory during parallel processing)
      # Time::HiRes (standard module of Perl)
    ]}
    wrapProgram $out/bin/genhtml --set PERL5LIB ${makeFullPerlPath [ DateTime TimeDate CaptureTiny ]}
    wrapProgram $out/bin/genpng --set PERL5LIB ${makeFullPerlPath [ GD ]}
  '';

  meta = with lib; {
    description = "Code coverage tool that enhances GNU gcov";

    longDescription =
      '' LCOV is an extension of GCOV, a GNU tool which provides information
         about what parts of a program are actually executed (i.e.,
         "covered") while running a particular test case.  The extension
         consists of a set of PERL scripts which build on the textual GCOV
         output to implement the following enhanced functionality such as
         HTML output.
      '';

    homepage = "https://ltp.sourceforge.net/coverage/lcov.php";
    license = lib.licenses.gpl2Plus;

    platforms = platforms.all;
  };
}
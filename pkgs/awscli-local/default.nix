{ lib, fetchFromGitHub, python3Packages }:

let
  localstack-client = python3Packages.buildPythonPackage rec {
    pname = "localstack-client";
    version = "1.35";

    src = fetchFromGitHub {
      owner = "localstack";
      repo = "localstack-python-client";
      rev = "4de1648209ca8909be1537c74bb0d9ee965f48ae";
      sha256 = "sha256-htDu+xhnoxWD6KjcBaWN9RQUYxEdiJ4BuZ3eP2V/Dks=";
    };

    propagatedBuildInputs = [ python3Packages.boto3 ];

    meta = with lib; {
      description = "🐍 A lightweight Python client for LocalStack";
      license = licenses.asl20;
      homepage = "https://localstack.cloud/";
      platforms = platforms.all;
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "awscli-local";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "localstack";
    repo = pname;
    rev = "651d037f32ece5a80b4f52c1e97f33cfe65d6a03";
    sha256 = "sha256-sZaWmohuL0aLChj51ctLBrbPigwYm86xydshpq1cBY0=";
  };

  propagatedBuildInputs = [ localstack-client ];

  meta = {
    description = "💲 \"awslocal\" - Thin wrapper around the \"aws\" command line interface for use with LocalStack";
    license = lib.licenses.asl20;
    homepage = "https://localstack.cloud/";
    platforms = lib.platforms.unix;
  };
}

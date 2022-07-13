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
    rev = "cca765afc7d0e63455d6ca36f277e36c2c15412a";
    sha256 = "sha256-qypjmevA3uFeqYMzuMIMhC/V3hXBWr2sDdpbIzmXfsM=";
  };

  propagatedBuildInputs = [ localstack-client ];

  meta = {
    description = "💲 \"awslocal\" - Thin wrapper around the \"aws\" command line interface for use with LocalStack";
    license = lib.licenses.asl20;
    homepage = "https://localstack.cloud/";
    platforms = lib.platforms.unix;
  };
}

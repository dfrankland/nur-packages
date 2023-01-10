{ lib, fetchFromGitHub, python3Packages }:

let
  localstack-client = python3Packages.buildPythonPackage rec {
    pname = "localstack-client";
    version = "1.39";

    src = fetchFromGitHub {
      owner = "localstack";
      repo = "localstack-python-client";
      rev = "f1e538ad23700e5b1afe98720404f4801475e470";
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
    rev = "26bb3ea62f8a514727662114ea12418fda890588";
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

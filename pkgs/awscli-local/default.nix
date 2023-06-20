{ lib, fetchFromGitHub, python3Packages }:

let
  localstack-client = python3Packages.buildPythonPackage rec {
    pname = "localstack-client";
    version = "2.2";

    src = fetchFromGitHub {
      owner = "localstack";
      repo = "localstack-python-client";
      rev = "579d50ce443074e9e5c2c96cef5b62098444aa33";
      sha256 = "sha256-JLpKldHO9zZwft/0NNuRL2ekJ4nf+dG+CxDPMzdMD4I=";
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
    rev = "58544ce0e18a56ea6fed0613642d3773f4987a20";
    sha256 = "sha256-85uGZ/mliHmUumfYD/URIFrW04zG8LKsMou/bHqtGf8=";
  };

  propagatedBuildInputs = [ localstack-client ];

  meta = {
    description = "💲 \"awslocal\" - Thin wrapper around the \"aws\" command line interface for use with LocalStack";
    license = lib.licenses.asl20;
    homepage = "https://localstack.cloud/";
    platforms = lib.platforms.unix;
  };
}

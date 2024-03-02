{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "cloudflare-ddns";
  version = "4ea9ba5745ab65ffd250091e865d140675730f82";

  src = fetchFromGitHub {
    owner = "timothymiller";
    repo = pname;
    rev = "4ea9ba5745ab65ffd250091e865d140675730f82";
    sha256 = "sha256-fTWx+6GP6x33DA5gOA+7dNIThGkP0Eka9qVdNtz9XAo=";
  };

  propagatedBuildInputs = [ python3Packages.requests ];

  preBuild = ''
    cat >setup.py <<'EOF'
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

        # TODO: Remove this hack when requests is updated
        # https://github.com/timothymiller/cloudflare-ddns/pull/137
        install_requires = ['requests>=2.28.2']

    setup(
      name='${pname}',
      version='0.1.0',
      packages=[],
      install_requires=install_requires,
      scripts=['${pname}.py'],
    )
    EOF
  '';

  postInstall = ''
    mv -v $out/bin/${pname}.py $out/bin/${pname}
  '';

  meta = {
    description = "🎉🌩️ Dynamic DNS (DDNS) service based on Cloudflare! Access your home network remotely via a custom domain name without a static IP!";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/timothymiller/cloudflare-ddns";
    platforms = lib.platforms.unix;
  };
}

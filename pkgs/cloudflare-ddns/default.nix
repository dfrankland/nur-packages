{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "cloudflare-ddns";
  version = "7e6d74f";

  src = fetchFromGitHub {
    owner = "timothymiller";
    repo = pname;
    rev = "7e6d74f1f6961668f0c2ece4fe500ae493dc5fdf";
    sha256 = "sha256-/AyTzY8Gw+Mt4OzwLUfMPUFwDE0v8dYs4xxCU2KNRvY=";
  };

  propagatedBuildInputs = [ python3Packages.requests ];

  preBuild = ''
    cat >setup.py <<'EOF'
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

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

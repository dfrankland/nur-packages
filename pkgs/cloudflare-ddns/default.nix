{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "cloudflare-ddns";
  version = "7e6d74f";

  src = fetchFromGitHub {
    owner = "timothymiller";
    repo = pname;
    rev = "6e92fc0d096eda45b62cdbc262a1a3ae3dd6be99";
    sha256 = "sha256-FRl6craMAY6E/DeOpNSSEy4ObcfUApfrs1C9QS3CDlo=";
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

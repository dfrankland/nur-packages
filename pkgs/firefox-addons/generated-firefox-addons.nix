{
  buildMozillaXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "trunk-for-github" = buildMozillaXpiAddon {
    pname = "trunk-for-github";
    version = "0.15.0";
    addonId = "trunk-github@trunk.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/4891014/trunk_for_github-0.15.0.xpi";
    sha256 = "9a9aeec9019f8e0a76c1e22557aceded3a792444c27adc4f375829c64eb547ef";
    meta = with lib; {
      homepage = "https://trunk.io";
      description = "Adds Trunk-focused functionality and UI improvements to GitHub.";
      license = licenses.mit;
      mozPermissions = ["storage" "cookies" "https://github.com/*"];
      platforms = platforms.all;
    };
  };
}

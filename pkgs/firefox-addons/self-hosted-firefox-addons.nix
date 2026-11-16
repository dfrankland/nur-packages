# Add-ons that Mozilla signs but does not host, so `mozilla-addons-to-nix` cannot
# reach them: an *unlisted* add-on has no AMO listing, so it has no slug to put in
# addons.json, and its GUID 404s on the public AMO API. The vendor self-hosts the
# signed .xpi and an `update_url` manifest instead.
#
# Kept in its own file because the generator rewrites
# generated-firefox-addons.nix wholesale — an entry added there would be lost on
# the next regeneration.
{
  buildMozillaXpiAddon,
  lib,
  writeScript,
}: {
  "trunk-for-github-staging" = buildMozillaXpiAddon {
    pname = "trunk-for-github-staging";
    version = "1.12.3";
    addonId = "trunk-for-github-staging@trunk.io";
    # The filename carries an AMO-assigned signing id, so it is not derivable
    # from the version — URL and hash both come from the updates.json pointer
    # that the updateScript below reads.
    url = "https://trunk.io/releases/browser-extension/staging/1.12.3/4b09ce2df7354daa82c4-1.12.3.xpi";
    sha256 = "52ea7a48c76e8aa30f9ed1ff9160d12d33f7580ee30d75e341dd53a61ed5679c";

    # Installs alongside the listed `trunk-for-github` rather than conflicting
    # with it: the staging build ships a different gecko id and suffixes its
    # injected-DOM markers, so both can be enabled in one profile.
    meta = with lib; {
      homepage = "https://trunk.io";
      description = "Staging channel of Trunk for GitHub — self-hosted, unlisted on AMO";
      license = licenses.mit;
      mozPermissions = [
        "storage"
        "cookies"
        "https://github.com/*"
        "https://trunk-staging.io/*"
        "https://*.trunk-staging.io/*"
        "https://app.trunk-staging.io/*"
        "http://localhost/*"
        "https://localhost/*"
        "http://127.0.0.1/*"
        "https://127.0.0.1/*"
      ];
      platforms = platforms.all;
    };

    # The same `updates.json` Firefox itself polls is the machine-readable source
    # for all three pinned values, so an update needs no separate download:
    # `update_hash` is the sha256 the publisher recorded, and `fetchurl` verifies
    # it on fetch anyway. `jq -e` makes a moved pointer or a renamed add-on id a
    # hard failure rather than a silent no-op.
    #
    # The sed range deliberately ends at this entry's `meta =` line rather than at
    # its closing brace: the three pinned attributes all sit above `meta`, while
    # everything below includes this script's own `s|version = ...|` templates,
    # which a whole-entry range would be free to rewrite.
    passthru.updateScript = writeScript "update-trunk-for-github-staging" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq gnused
      set -euo pipefail
      file=pkgs/firefox-addons/self-hosted-firefox-addons.nix
      id=trunk-for-github-staging@trunk.io
      pointer="$(curl -fsSL https://trunk.io/releases/browser-extension/staging/updates.json)"
      entry="$(printf '%s' "$pointer" | jq -e --arg id "$id" '.addons[$id].updates[0]')"
      version="$(printf '%s' "$entry" | jq -er .version)"
      url="$(printf '%s' "$entry" | jq -er .update_link)"
      sha256="$(printf '%s' "$entry" | jq -er .update_hash | sed 's/^sha256://')"
      sed -i "/\"trunk-for-github-staging\" = buildMozillaXpiAddon {/,/^    meta = / {
        s|version = \"[^\"]*\"|version = \"$version\"|
        s|url = \"[^\"]*\"|url = \"$url\"|
        s|sha256 = \"[^\"]*\"|sha256 = \"$sha256\"|
      }" "$file"
    '';
  };
}

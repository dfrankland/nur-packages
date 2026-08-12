{
  lib,
  stdenv,
  fetchurl,
}: {
  pname,
  version,
  addonId,
  url,
  sha256,
  meta,
  # Extra passthru attributes. The generator never emits this, so defaulting it
  # keeps the builder's interface exactly what `mozilla-addons-to-nix` produces;
  # it exists for the hand-maintained self-hosted add-ons, which carry their own
  # `updateScript` (the generated set is refreshed wholesale instead).
  passthru ? {},
  ...
}:
stdenv.mkDerivation {
  name = "${pname}-${version}";

  inherit meta;

  src = fetchurl {inherit url sha256;};

  preferLocalBuild = true;
  allowSubstitutes = true;

  passthru = passthru // {inherit addonId;};

  buildCommand = ''
    dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    mkdir -p "$dst"
    install -v -m644 "$src" "$dst/${addonId}.xpi"
  '';
}

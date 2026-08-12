# Firefox add-ons

Nix packages for Firefox add-ons from [addons.mozilla.org][amo], built the same
way as [rycee's `firefox-addons`][rycee-addons] using
[`mozilla-addons-to-nix`][matn].

Each add-on is exposed as a top-level package with a `firefox-addons-` prefix,
e.g.:

```console
$ nix build .#firefox-addons-trunk-for-github
```

The resulting derivation installs the `.xpi` under
`share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/<addonId>.xpi`,
which is what Firefox and home-manager's
`programs.firefox.profiles.<name>.extensions` expect.

## Files

- `addons.json` — the source of truth for the **AMO-hosted** add-ons.
- `generated-firefox-addons.nix` — **generated**, do not edit by hand. Produced
  from `addons.json` by `mozilla-addons-to-nix`.
- `self-hosted-firefox-addons.nix` — hand-maintained; add-ons AMO signs but does
  not host, which the generator cannot see. See
  [Self-hosted add-ons](#self-hosted-add-ons).
- `build-mozilla-xpi-addon.nix` — the builder that turns each entry into a
  derivation. Its name and argument (`buildMozillaXpiAddon`) match what the
  generator emits, so regenerating never requires editing it.
- `default.nix` — wires the builder to both sets (self-hosted entries win on a
  name collision).

## Adding an add-on

1. Find the add-on's **slug** — the last path segment of its AMO URL. For
   `https://addons.mozilla.org/en-US/firefox/addon/trunk-for-github/` the slug
   is `trunk-for-github`.

2. Add an entry to `addons.json`:

   ```json
   {
     "slug": "ublock-origin"
   }
   ```

   Optional keys:

   - `pname` — override the package name (defaults to the slug).
   - `license` — override the license when AMO reports it incorrectly, e.g.:

     ```json
     {
       "slug": "some-addon",
       "license": {
         "tag": "custom",
         "shortName": "proprietary",
         "fullName": "Some proprietary license",
         "url": "https://example.com/license",
         "free": false
       }
     }
     ```

3. Regenerate (see below).

## Self-hosted add-ons

Some add-ons are **unlisted**: AMO signs the `.xpi` (automated, no human review)
but hosts nothing, and the vendor self-distributes it behind an `update_url`
manifest. `mozilla-addons-to-nix` cannot reach these — an unlisted add-on has no
AMO listing, so there is no slug for `addons.json`, and its GUID 404s on the
public AMO API. Adding one to `addons.json` therefore does nothing.

They live in `self-hosted-firefox-addons.nix` instead, using the same
`buildMozillaXpiAddon` builder (which only wants a `url` and a `sha256`, so it is
indifferent to where the file comes from). **Keep them out of
`generated-firefox-addons.nix`** — the generator rewrites that file wholesale and
a hand-added entry is silently lost on the next regeneration.

Each entry carries its own `passthru.updateScript`, because the whole-set
regeneration above cannot update it. Refresh one by name:

```console
$ ./update.sh firefox-addons-trunk-for-github-staging
```

`update.sh` decides which path a target takes by looking it up in
`generated-firefox-addons.nix` (`is_generated_addon`), so a name under the
`firefox-addons-` prefix that is *not* in the generated set runs its own script
rather than triggering the AMO regeneration.

Current entries:

| Package | Add-on | Pointer |
| --- | --- | --- |
| `firefox-addons-trunk-for-github-staging` | Trunk for GitHub (Staging), `trunk-for-github-staging@trunk.io` | `https://trunk.io/releases/browser-extension/staging/updates.json` |

It installs alongside the listed `firefox-addons-trunk-for-github` rather than
conflicting with it: the staging build ships a different gecko id, so both can be
enabled in one profile.

## Updating / regenerating

`generated-firefox-addons.nix` pins each add-on to a specific version and hash.
To pick up new versions or new `addons.json` entries, regenerate it with
[`mozilla-addons-to-nix`][matn]:

```console
$ cd pkgs/firefox-addons
$ nix run sourcehut:~rycee/mozilla-addons-to-nix -- addons.json generated-firefox-addons.nix
```

Then format and sanity-check:

```console
$ nix run nixpkgs#alejandra -- generated-firefox-addons.nix
$ nix flake check
```

Commit the updated `addons.json` and `generated-firefox-addons.nix` together.

### Manual update (single add-on)

For a quick one-off bump without the generator, pull the current metadata from
the AMO API and edit `generated-firefox-addons.nix` directly:

```console
$ curl -sL https://addons.mozilla.org/api/v5/addons/addon/<slug>/ | \
    python3 -m json.tool
```

Use these fields:

- `guid` → `addonId`
- `current_version.version` → `version`
- `current_version.file.url` → `url`
- `current_version.file.hash` (`sha256:<hex>`) → `sha256` (the bare hex value;
  `fetchurl` accepts it as-is, matching the generator's output).

[amo]: https://addons.mozilla.org/
[rycee-addons]: https://github.com/nix-community/nur-combined/tree/main/repos/rycee/pkgs/firefox-addons
[matn]: https://git.sr.ht/~rycee/mozilla-addons-to-nix

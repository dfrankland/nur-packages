# nur-packages-template

**A template for [NUR](https://github.com/nix-community/NUR) repositories**

## Setup

1. Click on [Use this template](https://github.com/nix-community/nur-packages-template/generate) to start a repo based on this template. (Do _not_ fork it.)
2. Add your packages to the [pkgs](./pkgs) directory and to
   [default.nix](./default.nix)
   * Remember to mark the broken packages as `broken = true;` in the `meta`
     attribute, or travis (and consequently caching) will fail!
   * Library functions, modules and overlays go in the respective directories
3. Choose your CI: Depending on your preference you can use github actions (recommended) or [Travis ci](https://travis-ci.com).
   - Github actions: Change your NUR repo name and optionally add a cachix name in [.github/workflows/build.yml](./.github/workflows/build.yml) and change the cron timer
     to a random value as described in the file
   - Travis ci: Change your NUR repo name and optionally your cachix repo name in 
   [.travis.yml](./.travis.yml). Than enable travis in your repo. You can add a cron job in the repository settings on travis to keep your cachix cache fresh
5. Change your travis and cachix names on the README template section and delete
   the rest
6. [Add yourself to NUR](https://github.com/nix-community/NUR#how-to-add-your-own-repository)

## README template

# nur-packages

**My personal [NUR](https://github.com/nix-community/NUR) repository**

<!-- Remove this if you don't use github actions -->
![Build and populate cache](https://github.com/<YOUR-GITHUB-USER>/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)

<!--
Uncomment this if you use travis:

[![Build Status](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages.svg?branch=master)](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages)
-->
[![Cachix Cache](https://img.shields.io/badge/cachix-<YOUR_CACHIX_CACHE_NAME>-blue.svg)](https://<YOUR_CACHIX_CACHE_NAME>.cachix.org)

## Updating packages

Most packages carry a `passthru.updateScript` (the nixpkgs convention). Each one
knows where to look for new versions — see the comment next to it in the
package's `default.nix` — and rewrites the pinned version and hash(es) in place.

Run them via `./update.sh`, which must be run from the repository root:

```console
$ ./update.sh                  # update every package that has an updateScript
$ ./update.sh trunk tailscale  # update only the named packages
$ ./update.sh firefox-addons   # regenerate the Firefox add-on set
```

The runner realises and executes each package's update script, then runs
`nix fmt` so the result satisfies `nix flake check`. Nothing is committed
automatically — review the result and commit it yourself:

```console
$ git diff
$ nix flake check   # optional: build-check before committing
```

Where the scripts get their versions:

- **GitHub releases** (`drata-agent`, `ferdium`, `headscale-ui`, `macthrottle`,
  `mullvad-vpn`, `qmk_toolbox`, `ungoogled-chromium`, `wezterm`) — the latest
  tag, via `nix-update`.
- **Homebrew cask API** (`epilogue-playback`, `loom`, `rippling`,
  `signal-desktop`, `wifiman-desktop`) — `formulae.brew.sh/api/cask/<name>.json`.
- **Vendor feeds** — `chromium` (`LAST_CHANGE`), `tailscale`
  (`pkgs.tailscale.com/stable/?mode=json`), `github-desktop` (cask),
  `docker-desktop` (Sparkle appcast), `trunk` (`trunk.io/releases/latest`),
  `wavebox` (per-platform `latest.json`).
- **Firefox add-ons** are a generated set, refreshed with
  [`mozilla-addons-to-nix`](https://git.sr.ht/~rycee/mozilla-addons-to-nix); see
  [`pkgs/firefox-addons/README.md`](./pkgs/firefox-addons/README.md).

To update a single package without the runner, run its script directly (again
from the repository root):

```console
$ "$(nix build --no-link --print-out-paths .#tailscale.updateScript)"
```

> **Note:** packages that are only built on `aarch64-darwin` but keep Linux
> placeholder hashes (`epilogue-playback`, `wifiman-desktop`) only get their
> darwin hash refreshed; the Linux hashes must still be filled in by hand.


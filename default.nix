{pkgs ? import <nixpkgs> {}}: let
  unpackdmg = pkgs.callPackage ./pkgs/unpackdmg {};
  lib = import ./lib {inherit pkgs;};
  modules = import ./modules;
  overlays = import ./overlays;
  # Firefox add-ons are flattened into the top-level package set with a
  # `firefox-addons-` prefix (e.g. `firefox-addons-trunk-for-github`).
  firefoxAddons =
    pkgs.lib.mapAttrs'
    (name: pkgs.lib.nameValuePair "firefox-addons-${name}")
    (import ./pkgs/firefox-addons {inherit pkgs;});
in
  firefoxAddons
  // {
    chromium = pkgs.callPackage ./pkgs/chromium {};
    docker-desktop = pkgs.callPackage ./pkgs/docker-desktop {inherit unpackdmg;};
    drata-agent = pkgs.callPackage ./pkgs/drata-agent {inherit unpackdmg;};
    epilogue-playback = pkgs.callPackage ./pkgs/epilogue-playback {inherit unpackdmg;};
    ferdium = pkgs.callPackage ./pkgs/ferdium {};
    github-desktop = pkgs.callPackage ./pkgs/github-desktop {};
    headscale-ui = pkgs.callPackage ./pkgs/headscale-ui {};
    loom = pkgs.callPackage ./pkgs/loom {inherit unpackdmg;};
    macthrottle = pkgs.callPackage ./pkgs/macthrottle {};
    mullvad-vpn = pkgs.callPackage ./pkgs/mullvad-vpn {};
    qmk_toolbox = pkgs.callPackage ./pkgs/qmk_toolbox {};
    rippling = pkgs.callPackage ./pkgs/rippling {};
    signal-desktop = pkgs.callPackage ./pkgs/signal-desktop {inherit unpackdmg;};
    tailscale = pkgs.callPackage ./pkgs/tailscale {};
    trunk = pkgs.callPackage ./pkgs/trunk {};
    ungoogled-chromium = pkgs.callPackage ./pkgs/ungoogled-chromium {inherit unpackdmg;};
    inherit unpackdmg;
    wavebox = pkgs.callPackage ./pkgs/wavebox {};
    wezterm = pkgs.callPackage ./pkgs/wezterm {};
    wifiman-desktop = pkgs.callPackage ./pkgs/wifiman-desktop {};
  }

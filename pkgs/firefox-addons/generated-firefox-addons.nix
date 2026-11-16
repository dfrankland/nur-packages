{
  buildMozillaXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "2fas-two-factor-authentication" = buildMozillaXpiAddon {
    pname = "2fas-two-factor-authentication";
    version = "1.9.3";
    addonId = "admin@2fas.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/5155897/2fas_two_factor_authentication-1.9.3.xpi";
    sha256 = "024c8ca86e6d2883257bf0d379c9d796018b55ab7838f5e2a44133bd85e7552f";
    meta = with lib; {
      homepage = "https://2fas.com/";
      description = "2FAS Auth Browser Extension is simple, private, and secured: one click, one tap, and your 2FA token is automatically entered!";
      license = licenses.gpl3;
      mozPermissions = [
        "activeTab"
        "tabs"
        "storage"
        "unlimitedStorage"
        "notifications"
        "contextMenus"
        "webNavigation"
        "alarms"
        "https://*/*"
        "http://*/*"
      ];
      platforms = platforms.all;
    };
  };
  "multi-account-containers" = buildMozillaXpiAddon {
    pname = "multi-account-containers";
    version = "8.4.0";
    addonId = "@testpilot-containers";
    url = "https://addons.mozilla.org/firefox/downloads/file/5168122/multi_account_containers-8.4.0.xpi";
    sha256 = "10936d682e17bd2e8afa018bde94f927b50cf05973d6ef8ca3c54f807b2cf7ba";
    meta = with lib; {
      homepage = "https://github.com/mozilla/multi-account-containers/#readme";
      description = "Firefox Multi-Account Containers lets you keep parts of your online life separated into color-coded tabs. Cookies are separated by container, allowing you to use the web with multiple accounts and integrate Mozilla VPN for an extra layer of privacy.";
      license = licenses.mpl20;
      mozPermissions = [
        "<all_urls>"
        "activeTab"
        "cookies"
        "contextMenus"
        "contextualIdentities"
        "history"
        "idle"
        "management"
        "storage"
        "unlimitedStorage"
        "tabs"
        "webRequestBlocking"
        "webRequest"
      ];
      platforms = platforms.all;
    };
  };
  "onepassword-password-manager" = buildMozillaXpiAddon {
    pname = "onepassword-password-manager";
    version = "8.12.44.33";
    addonId = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
    url = "https://addons.mozilla.org/firefox/downloads/file/5203941/1password_x_password_manager-8.12.44.33.xpi";
    sha256 = "dd896610a3e6776582b76f180ea0d3180b03413a244314f9d3c6b08ec6c59819";
    meta = with lib; {
      homepage = "https://1password.com";
      description = "The best way to experience 1Password in your browser. Easily sign in to sites, generate passwords, and store secure information, including logins, credit cards, notes, and more.";
      license = {
        shortName = "1pwd";
        fullName = "Service Agreement for 1Password users and customers";
        url = "https://1password.com/legal/terms-of-service/";
        free = false;
      };
      mozPermissions = [
        "<all_urls>"
        "alarms"
        "clipboardWrite"
        "contextMenus"
        "downloads"
        "idle"
        "management"
        "nativeMessaging"
        "notifications"
        "privacy"
        "scripting"
        "storage"
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "declarativeNetRequestWithHostAccess"
        "https://*/*"
        "http://localhost/*"
        "https://*.1password.ca/*"
        "https://*.1password.com/*"
        "https://*.1password.eu/*"
        "https://*.b5dev.ca/*"
        "https://*.b5dev.com/*"
        "https://*.b5dev.eu/*"
        "https://*.b5local.com/*"
        "https://*.b5staging.com/*"
        "https://*.b5test.ca/*"
        "https://*.b5test.com/*"
        "https://*.b5test.eu/*"
        "https://*.b5rev.com/*"
        "https://app.kolide.com/*"
        "https://app.kolide.ca/*"
        "https://app.kolide.eu/*"
        "https://auth.kolide.com/*"
        "https://auth.kolide.ca/*"
        "https://auth.kolide.eu/*"
        "https://autofill.me/*"
      ];
      platforms = platforms.all;
    };
  };
  "react-devtools" = buildMozillaXpiAddon {
    pname = "react-devtools";
    version = "8.0.0";
    addonId = "@react-devtools";
    url = "https://addons.mozilla.org/firefox/downloads/file/5018049/react_devtools-8.0.0.xpi";
    sha256 = "ad429f0b0db914a0505591f70160005d7c3e1a7865128c3bfa46392d28be34be";
    meta = with lib; {
      homepage = "https://github.com/facebook/react";
      description = "React Developer Tools is a tool that allows you to inspect a React tree, including the component hierarchy, props, state, and more. To get started, just open the Firefox devtools and switch to the \"⚛️ Components\" or \"⚛️ Profiler\" tab.";
      license = licenses.mit;
      mozPermissions = [
        "scripting"
        "storage"
        "tabs"
        "clipboardWrite"
        "devtools"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "reduxdevtools" = buildMozillaXpiAddon {
    pname = "reduxdevtools";
    version = "3.2.12";
    addonId = "extension@redux.devtools";
    url = "https://addons.mozilla.org/firefox/downloads/file/5141168/reduxdevtools-3.2.12.xpi";
    sha256 = "0ea0b00c23ea302ea6145a29e8c28fd5c94145dfbeab18016744fe597da1045a";
    meta = with lib; {
      homepage = "https://github.com/reduxjs/redux-devtools";
      description = "DevTools for Redux with actions history, undo and replay.";
      license = licenses.mit;
      mozPermissions = [
        "notifications"
        "contextMenus"
        "tabs"
        "storage"
        "devtools"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
  "refined-github" = buildMozillaXpiAddon {
    pname = "refined-github";
    version = "26.11.6";
    addonId = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
    url = "https://addons.mozilla.org/firefox/downloads/file/5216077/refined_github-26.11.6.xpi";
    sha256 = "877286e8034e868ba79b325195dbd7ddea9726dcb326568f1c656d057ae83fff";
    meta = with lib; {
      homepage = "https://github.com/refined-github/refined-github";
      description = "Simplifies the GitHub interface and adds many useful features.";
      license = licenses.mit;
      mozPermissions = [
        "storage"
        "scripting"
        "contextMenus"
        "activeTab"
        "alarms"
        "https://github.com/*"
        "https://gist.github.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "rust-search-extension" = buildMozillaXpiAddon {
    pname = "rust-search-extension";
    version = "2.0.2";
    addonId = "{04188724-64d3-497b-a4fd-7caffe6eab29}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4435641/rust_search_extension-2.0.2.xpi";
    sha256 = "10f521001a9fd9c7b8c5f8133daa74de01a5db33fb283b6b472b49c183e8418c";
    meta = with lib; {
      homepage = "https://rust.extension.sh";
      description = "The ultimate search extension for Rust\n\nSearch std docs, crates, builtin attributes, official books, and error codes, etc in your address bar instantly.\nhttps://rust.extension.sh";
      license = licenses.mpl20;
      mozPermissions = [
        "storage"
        "unlimitedStorage"
        "*://docs.rs/*"
        "*://doc.rust-lang.org/*"
        "*://rust.extension.sh/update"
      ];
      platforms = platforms.all;
    };
  };
  "search-by-image" = buildMozillaXpiAddon {
    pname = "search-by-image";
    version = "8.5.3";
    addonId = "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4840197/search_by_image-8.5.3.xpi";
    sha256 = "ba604478b50f5c46e13011ea7e3e2906abc7b1b72cb7e87b02c4fbdefa64ae37";
    meta = with lib; {
      homepage = "https://github.com/dessant/search-by-image#readme";
      description = "A powerful reverse image search tool, with support for various search engines, such as Google, Bing, Yandex, Baidu and TinEye.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "tabs"
        "activeTab"
        "notifications"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "scripting"
        "http://*/*"
        "https://*/*"
        "file:///*"
      ];
      platforms = platforms.all;
    };
  };
  "tabliss" = buildMozillaXpiAddon {
    pname = "tabliss";
    version = "2.6.0";
    addonId = "extension@tabliss.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
    sha256 = "de766810f234b1c13ffdb7047ae6cbf06ed79c3d08b51a07e4766fadff089c0f";
    meta = with lib; {
      homepage = "https://tabliss.io";
      description = "A beautiful New Tab page with many customisable backgrounds and widgets that does not require any permissions.";
      license = licenses.gpl3;
      mozPermissions = ["storage"];
      platforms = platforms.all;
    };
  };
  "trunk-for-github" = buildMozillaXpiAddon {
    pname = "trunk-for-github";
    version = "1.12.3";
    addonId = "trunk-github@trunk.io";
    url = "https://addons.mozilla.org/firefox/downloads/file/5245760/trunk_for_github-1.12.3.xpi";
    sha256 = "efa9ddd44e462d3f82c326abda6e2269ea9706841fc244fdfd73614ddc095f23";
    meta = with lib; {
      homepage = "https://trunk.io";
      description = "Adds Trunk-focused functionality and UI improvements to GitHub.";
      license = licenses.mit;
      mozPermissions = [
        "storage"
        "cookies"
        "webRequest"
        "webRequestBlocking"
        "https://github.com/*"
        "https://cursor.com/*"
        "https://gitlab.com/*"
      ];
      platforms = platforms.all;
    };
  };
  "ublock-origin" = buildMozillaXpiAddon {
    pname = "ublock-origin";
    version = "1.76.4";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/5257481/ublock_origin-1.76.4.xpi";
    sha256 = "66d0e3f21ce3b32b1bc0a9399b93cb2c9aa598ef18805d92118c76f66e266c1e";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "dns"
        "menus"
        "privacy"
        "publicSuffix"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "http://*/*"
        "https://*/*"
        "file://*/*"
        "https://easylist.to/*"
        "https://*.fanboy.co.nz/*"
        "https://filterlists.com/*"
        "https://forums.lanik.us/*"
        "https://github.com/*"
        "https://*.github.io/*"
        "https://github.com/uBlockOrigin/*"
        "https://ublockorigin.github.io/*"
        "https://*.reddit.com/r/uBlockOrigin/*"
      ];
      platforms = platforms.all;
    };
  };
  "wayback-machine" = buildMozillaXpiAddon {
    pname = "wayback-machine";
    version = "3.2";
    addonId = "wayback_machine@mozilla.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4047136/wayback_machine_new-3.2.xpi";
    sha256 = "75da413fee7c28e22ed61380f959888ec80c14e2a38f7b6f9d622f8a4ea853e4";
    meta = with lib; {
      homepage = "https://archive.org";
      description = "Welcome to the Official Internet Archive Wayback Machine Browser Extension! Go back in time to see how a website has changed through the history of the Web. Save websites, view missing 404 Not Found pages, or read archived books &amp; papers.";
      license = licenses.gpl3;
      mozPermissions = [
        "activeTab"
        "cookies"
        "contextMenus"
        "notifications"
        "storage"
        "webRequest"
        "webRequestBlocking"
        "https://archive.org/*"
        "https://*.archive.org/*"
        "https://hypothes.is/*"
        "<all_urls>"
        "http://*.wikipedia.org/*"
        "https://*.wikipedia.org/*"
      ];
      platforms = platforms.all;
    };
  };
  "web-archives" = buildMozillaXpiAddon {
    pname = "web-archives";
    version = "7.3.3";
    addonId = "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4871262/view_page_archive-7.3.3.xpi";
    sha256 = "81ca25bd41392cf4b03d4c1c4c39ebd5a4eaa840ef8a4d26f84b1dd396999a34";
    meta = with lib; {
      homepage = "https://github.com/dessant/web-archives#readme";
      description = "View archived and cached versions of web pages on various search engines, such as the Wayback Machine and Archive․is.";
      license = licenses.gpl3Only;
      mozPermissions = [
        "alarms"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "tabs"
        "activeTab"
        "notifications"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "scripting"
        "http://*/*"
        "https://*/*"
        "file:///*"
      ];
      platforms = platforms.all;
    };
  };
}

{ pkgs, python, ... }:
with builtins;
with pkgs.lib;
let
  pypi_fetcher_src = builtins.fetchTarball {
    name = "nix-pypi-fetcher-2";
    url = "https://github.com/DavHau/nix-pypi-fetcher-2/tarball/f83bd320cf92d2c3fcf891f16195189aab0db8fe";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "sha256-y7YGrGcH/RuoEG4LNLghOeecnVYS1lNhhso9NFSA2WA=";
  };
  pypiFetcher = import pypi_fetcher_src { inherit pkgs; };
  fetchPypi = pypiFetcher.fetchPypi;
  fetchPypiWheel = pypiFetcher.fetchPypiWheel;
  pkgsData = fromJSON ''{"asgiref": {"name": "asgiref", "ver": "3.7.2", "build_inputs": [], "prop_build_inputs": ["typing-extensions"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "asgiref-3.7.2-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "async-timeout": {"name": "async-timeout", "ver": "4.0.2", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "async_timeout-4.0.2-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "coverage": {"name": "coverage", "ver": "4.5.1", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "sdist", "wheel_fname": null, "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "django": {"name": "django", "ver": "3.1.14", "build_inputs": [], "prop_build_inputs": ["sqlparse", "asgiref", "pytz"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "Django-3.1.14-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "django-cachalot": {"name": "django-cachalot", "ver": "2.3.5", "build_inputs": [], "prop_build_inputs": ["django"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "django_cachalot-2.3.5-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "django-cors-headers": {"name": "django-cors-headers", "ver": "3.11.0", "build_inputs": [], "prop_build_inputs": ["django"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "django_cors_headers-3.11.0-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "django-discover-runner": {"name": "django-discover-runner", "ver": "1.0", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "django_discover_runner-1.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "django-redis": {"name": "django-redis", "ver": "4.12.1", "build_inputs": [], "prop_build_inputs": ["redis", "django"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "django_redis-4.12.1-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "djangorestframework": {"name": "djangorestframework", "ver": "3.14.0", "build_inputs": [], "prop_build_inputs": ["django", "pytz"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "djangorestframework-3.14.0-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "gunicorn": {"name": "gunicorn", "ver": "20.1.0", "build_inputs": [], "prop_build_inputs": ["setuptools"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "gunicorn-20.1.0-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "mimeparse": {"name": "mimeparse", "ver": "0.1.3", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "sdist", "wheel_fname": null, "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "psycopg2-binary": {"name": "psycopg2-binary", "ver": "2.9.5", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "psycopg2_binary-2.9.5-cp39-cp39-macosx_11_0_arm64.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "python-dateutil": {"name": "python-dateutil", "ver": "2.8.1", "build_inputs": [], "prop_build_inputs": ["six"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "python_dateutil-2.8.1-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "python-mimeparse": {"name": "python-mimeparse", "ver": "1.6.0", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "python_mimeparse-1.6.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pytz": {"name": "pytz", "ver": "2023.3", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "pytz-2023.3-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "redis": {"name": "redis", "ver": "4.5.5", "build_inputs": [], "prop_build_inputs": ["async-timeout"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "redis-4.5.5-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "setuptools": {"name": "setuptools", "ver": "57.2.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "nixpkgs", "wheel_fname": null, "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "six": {"name": "six", "ver": "1.16.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "six-1.16.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "sqlparse": {"name": "sqlparse", "ver": "0.4.4", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "sqlparse-0.4.4-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "typing-extensions": {"name": "typing-extensions", "ver": "4.6.2", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "typing_extensions-4.6.2-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "unipath": {"name": "unipath", "ver": "1.1", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "sdist", "wheel_fname": null, "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}}'';
  isPyModule = pkg:
    isAttrs pkg && hasAttr "pythonModule" pkg;
  normalizeName = name: (replaceStrings [ "_" ] [ "-" ] (toLower name));
  depNamesOther = [
    "depsBuildBuild"
    "depsBuildBuildPropagated"
    "nativeBuildInputs"
    "propagatedNativeBuildInputs"
    "depsBuildTarget"
    "depsBuildTargetPropagated"
    "depsHostHost"
    "depsHostHostPropagated"
    "depsTargetTarget"
    "depsTargetTargetPropagated"
    "checkInputs"
    "installCheckInputs"
  ];
  depNamesAll = depNamesOther ++ [
    "propagatedBuildInputs"
    "buildInputs"
  ];
  removeUnwantedPythonDeps = pythonSelf: pname: inputs:
    # Do not remove any deps if provider is nixpkgs and actual dependencies are unknown.
    # Otherwise we risk removing dependencies which are needed.
    if pkgsData."${pname}".provider_info.provider == "nixpkgs"
      &&
      (pkgsData."${pname}".build_inputs == null
        || pkgsData."${pname}".prop_build_inputs == null) then
      inputs
    else
      filter
        (dep:
          if ! isPyModule dep || pkgsData ? "${normalizeName (get_pname dep)}" then
            true
          else
            trace "removing dependency ${dep.name} from ${pname}" false)
        inputs;
  updatePythonDeps = newPkgs: pkg:
    if ! isPyModule pkg then pkg else
    let
      pname = normalizeName (get_pname pkg);
      newP =
        # All packages with a pname that already exists in our overrides must be replaced with our version.
        # Otherwise we will have a collision
        if newPkgs ? "${pname}" && pkg != newPkgs."${pname}" then
          trace "Updated inherited nixpkgs dep ${pname} from ${pkg.version} to ${newPkgs."${pname}".version}"
            newPkgs."${pname}"
        else
          pkg;
    in
    newP;
  updateAndRemoveDeps = pythonSelf: name: inputs:
    removeUnwantedPythonDeps pythonSelf name (map (dep: updatePythonDeps pythonSelf dep) inputs);
  cleanPythonDerivationInputs = pythonSelf: name: oldAttrs:
    mapAttrs (n: v: if elem n depNamesAll then updateAndRemoveDeps pythonSelf name v else v) oldAttrs;
  override = pkg:
    if hasAttr "overridePythonAttrs" pkg then
      pkg.overridePythonAttrs
    else
      pkg.overrideAttrs;
  nameMap = {
    pytorch = "torch";
  };
  get_pname = pkg:
    let
      res = tryEval (
        if pkg ? src.pname then
          pkg.src.pname
        else if pkg ? pname then
          let pname = pkg.pname; in
          if nameMap ? "${pname}" then nameMap."${pname}" else pname
        else ""
      );
    in
    toString res.value;
  get_passthru = pypi_name: nix_name:
    # if pypi_name is in nixpkgs, we must pick it, otherwise risk infinite recursion.
    let
      python_pkgs = python.pkgs;
      pname = if hasAttr "${pypi_name}" python_pkgs then pypi_name else nix_name;
    in
    if hasAttr "${pname}" python_pkgs then
      let
        result = (tryEval
          (if isNull python_pkgs."${pname}" then
            { }
          else
            python_pkgs."${pname}".passthru));
      in
      if result.success then result.value else { }
    else { };
  allCondaDepsRec = pkg:
    let
      directCondaDeps =
        filter (p: p ? provider && p.provider == "conda") (pkg.propagatedBuildInputs or [ ]);
    in
    directCondaDeps ++ filter (p: ! directCondaDeps ? p) (map (p: p.allCondaDeps) directCondaDeps);
  tests_on_off = enabled: pySelf: pySuper:
    let
      mod = {
        doCheck = enabled;
        doInstallCheck = enabled;
      };
    in
    {
      buildPythonPackage = args: pySuper.buildPythonPackage (args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      });
      buildPythonApplication = args: pySuper.buildPythonPackage (args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      });
    };
  pname_passthru_override = pySelf: pySuper: {
    fetchPypi = args: (pySuper.fetchPypi args).overrideAttrs (oa: {
      passthru = { inherit (args) pname; };
    });
  };
  mergeOverrides = with pkgs.lib; foldl composeExtensions (self: super: { });
  merge_with_overr = enabled: overr:
    mergeOverrides [ (tests_on_off enabled) pname_passthru_override overr ];
  select_pkgs = ps: [
    ps."coverage"
    ps."django"
    ps."django-cachalot"
    ps."django-cors-headers"
    ps."django-discover-runner"
    ps."django-redis"
    ps."djangorestframework"
    ps."gunicorn"
    ps."mimeparse"
    ps."psycopg2-binary"
    ps."python-dateutil"
    ps."python-mimeparse"
    ps."unipath"
  ];
  overrides' = manylinux1: autoPatchelfHook: merge_with_overr false (python-self: python-super:
    let
      all = {
        "asgiref" = python-self.buildPythonPackage {
          pname = "asgiref";
          version = "3.7.2";
          src = fetchPypiWheel "asgiref" "3.7.2" "asgiref-3.7.2-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "asgiref" "asgiref") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ typing-extensions ];
        };
        "async-timeout" = python-self.buildPythonPackage {
          pname = "async-timeout";
          version = "4.0.2";
          src = fetchPypiWheel "async-timeout" "4.0.2" "async_timeout-4.0.2-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "async-timeout" "async-timeout") // { provider = "wheel"; };
        };
        "coverage" = override python-super."coverage" (oldAttrs:
          # filter out unwanted dependencies and replace colliding packages
          let cleanedAttrs = cleanPythonDerivationInputs python-self "coverage" oldAttrs; in cleanedAttrs // {
            pname = "coverage";
            version = "4.5.1";
            passthru = (get_passthru "coverage" "coverage") // { provider = "sdist"; };
            buildInputs = with python-self; (cleanedAttrs.buildInputs or [ ]) ++ [ ];
            propagatedBuildInputs =
              (cleanedAttrs.propagatedBuildInputs or [ ])
                ++ (with python-self; [ ]);
            src = fetchPypi "coverage" "4.5.1";
          }
        );
        "django" = python-self.buildPythonPackage {
          pname = "django";
          version = "3.1.14";
          src = fetchPypiWheel "django" "3.1.14" "Django-3.1.14-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "django" "django_3") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ asgiref pytz sqlparse ];
        };
        "django-cachalot" = python-self.buildPythonPackage {
          pname = "django-cachalot";
          version = "2.3.5";
          src = fetchPypiWheel "django-cachalot" "2.3.5" "django_cachalot-2.3.5-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "django-cachalot" "django-cachalot") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ django ];
        };
        "django-cors-headers" = python-self.buildPythonPackage {
          pname = "django-cors-headers";
          version = "3.11.0";
          src = fetchPypiWheel "django-cors-headers" "3.11.0" "django_cors_headers-3.11.0-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "django-cors-headers" "django-cors-headers") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ django ];
        };
        "django-discover-runner" = python-self.buildPythonPackage {
          pname = "django-discover-runner";
          version = "1.0";
          src = fetchPypiWheel "django-discover-runner" "1.0" "django_discover_runner-1.0-py2.py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "django-discover-runner" "django-discover-runner") // { provider = "wheel"; };
        };
        "django-redis" = python-self.buildPythonPackage {
          pname = "django-redis";
          version = "4.12.1";
          src = fetchPypiWheel "django-redis" "4.12.1" "django_redis-4.12.1-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "django-redis" "django-redis") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ django redis ];
        };
        "djangorestframework" = python-self.buildPythonPackage {
          pname = "djangorestframework";
          version = "3.14.0";
          src = fetchPypiWheel "djangorestframework" "3.14.0" "djangorestframework-3.14.0-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "djangorestframework" "djangorestframework") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ django pytz ];
        };
        "gunicorn" = python-self.buildPythonPackage {
          pname = "gunicorn";
          version = "20.1.0";
          src = fetchPypiWheel "gunicorn" "20.1.0" "gunicorn-20.1.0-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "gunicorn" "gunicorn") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ setuptools ];
        };
        "mimeparse" = python-self.buildPythonPackage {
          pname = "mimeparse";
          version = "0.1.3";
          src = fetchPypi "mimeparse" "0.1.3";
          passthru = (get_passthru "mimeparse" "mimeparse") // { provider = "sdist"; };
        };
        "psycopg2-binary" = python-self.buildPythonPackage {
          pname = "psycopg2-binary";
          version = "2.9.5";
          src = fetchPypiWheel "psycopg2-binary" "2.9.5" "psycopg2_binary-2.9.5-cp39-cp39-macosx_11_0_arm64.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "psycopg2-binary" "psycopg2-binary") // { provider = "wheel"; };
        };
        "python-dateutil" = python-self.buildPythonPackage {
          pname = "python-dateutil";
          version = "2.8.1";
          src = fetchPypiWheel "python-dateutil" "2.8.1" "python_dateutil-2.8.1-py2.py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "python-dateutil" "python-dateutil") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ six ];
        };
        "python-mimeparse" = python-self.buildPythonPackage {
          pname = "python-mimeparse";
          version = "1.6.0";
          src = fetchPypiWheel "python-mimeparse" "1.6.0" "python_mimeparse-1.6.0-py2.py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "python-mimeparse" "python-mimeparse") // { provider = "wheel"; };
        };
        "pytz" = python-self.buildPythonPackage {
          pname = "pytz";
          version = "2023.3";
          src = fetchPypiWheel "pytz" "2023.3" "pytz-2023.3-py2.py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "pytz" "pytz") // { provider = "wheel"; };
        };
        "redis" = python-self.buildPythonPackage {
          pname = "redis";
          version = "4.5.5";
          src = fetchPypiWheel "redis" "4.5.5" "redis-4.5.5-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "redis" "redis") // { provider = "wheel"; };
          propagatedBuildInputs = with python-self; [ async-timeout ];
        };
        "six" = python-self.buildPythonPackage {
          pname = "six";
          version = "1.16.0";
          src = fetchPypiWheel "six" "1.16.0" "six-1.16.0-py2.py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "six" "six") // { provider = "wheel"; };
        };
        "sqlparse" = python-self.buildPythonPackage {
          pname = "sqlparse";
          version = "0.4.4";
          src = fetchPypiWheel "sqlparse" "0.4.4" "sqlparse-0.4.4-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "sqlparse" "sqlparse") // { provider = "wheel"; };
        };
        "typing-extensions" = python-self.buildPythonPackage {
          pname = "typing-extensions";
          version = "4.6.2";
          src = fetchPypiWheel "typing-extensions" "4.6.2" "typing_extensions-4.6.2-py3-none-any.whl";
          format = "wheel";
          dontStrip = true;
          passthru = (get_passthru "typing-extensions" "typing-extensions") // { provider = "wheel"; };
        };
        "unipath" = python-self.buildPythonPackage {
          pname = "unipath";
          version = "1.1";
          src = fetchPypi "unipath" "1.1";
          passthru = (get_passthru "unipath" "unipath") // { provider = "sdist"; };
        };
      };
    in
    all);
in
{
  inherit select_pkgs;
  overrides = overrides';
}

with import <nixpkgs> {};
with pkgs;
with python35Packages;


let
  dectate = buildPythonPackage rec {
    name = "dectate-${version}";
    version = "0.12";
    buildInputs = [pytest];
    checkPhase = "py.test";
    src = fetchurl {
      url = "mirror://pypi/d/dectate/${name}.tar.gz";
      sha256="14hc65695r89x1ivm1gj3dcvsn2mk6a5ax01sl7s5cp1nyj8bfd3";
    };
  };
in buildPythonPackage rec {
  name = "sentaku-test";
  src = ./.;
  buildInputs = [
    gitFull
    less
    ncurses
    openssh
    bpython
    sqlite
    setuptools_scm
    tox
    pytest
    flake8
    sphinx
    requests2
    selenium
  ];
  checkPhase = "py.test";

  propagatedBuildInputs = [dectate attrs];


  shellHook=''
  export PS1="(${name}) \w \\$ \[$(tput sgr0)\]"
  export PYTHONPATH="$PYTHONPATH:./src"


  build_docs() {
    sphinx-build -b html -d build/sphinx-doctrees docs build/htmldocs
  }

  autobuild_docs() {
    watchmedo shell-command docs src -R \
    -c 'sphinx-build -b html -d build/sphinx-doctrees docs build/htmldocs'
  }

  clean() {
    find -name \*.pyc -delete
    find -name __pycache__ -delete
    rm -rf build/sphinx-doctrees build/htmldocs
  }

  build_fresh_docs() {
    clean
    build_docs
  }

  test_clean() {
    clean
    py.test
  }

  '';
}

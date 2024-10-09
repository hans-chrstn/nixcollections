{
  lib,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  makeWrapper,
  fetchPypi,
  python311Packages,
  python311Full,
}:
let 
  apps = import ./packages.nix { inherit fetchPypi python311Packages fetchFromGitHub; };
  desktopItem = makeDesktopItem {
    name = "lncrawler";
    exec = "lncrawler";
    desktopName = "Light Novel Crawler";
    icon = "lncrawl";
    categories = [];
  };
in
python311Packages.buildPythonPackage rec {
  pname = "lightnovel-crawler";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "dipu-bd";
    repo = "lightnovel-crawler";
    rev = "3.7.2";
    hash = "sha256-VVkPuk51NZ1703JYsmVVft0j3YgwvACxDp2zQganatg=";
  };

  format = "other";

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    python311Packages.python
  ];

  propagatedBuildInputs = [
    apps.ascii
    apps.pyease-grpc
    apps.pycryptodome
    apps.undetected-chromedriver
    python311Packages.regex
    python311Packages.packaging
    python311Packages.beautifulsoup4
    python311Packages.python-dotenv
    python311Packages.requests
    python311Packages.python-slugify
    python311Packages.colorama
    python311Packages.types-colorama
    python311Packages.tqdm
    python311Packages.js2py
    python311Packages.ebooklib
    python311Packages.pillow
    python311Packages.cloudscraper
    python311Packages.lxml
    python311Packages.questionary
    python311Packages.prompt-toolkit
    python311Packages.html5lib
    python311Packages.base58
    python311Packages.python-box
    python311Packages.webdriver-manager
    python311Packages.selenium
    python311Packages.readability-lxml
    python311Packages.python
    python311Packages.wheel
    python311Packages.black
    python311Packages.flake8
    python311Packages.setuptools
    python311Packages.discordpy
    python311Packages.python-telegram-bot
    python311Packages.websockets
  ];

  # installPhase = ''
  #   runHook preInstall
  #   mkdir -p $out/bin
  #   cp -r * $out/bin/
  #   install -D $out/bin/res/lncrawl.ico $out/share/icons/lncrawl.ico
  #   makeWrapper ${python311Full.interpreter} $out/bin/lncrawler \
  #     --set PYTHONPATH "$PYTHONPATH:$out/bin/lncrawl/__init__.py" \
  #     --add-flags "$out/bin/lncrawl"
  #   runHook postInstall
  # '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/lncrawl
    cp -r * $out/share/lncrawl

    install -D $out/share/lncrawl/res/lncrawl.ico $out/share/icons/lncrawl.ico

    makeWrapper ${python311Full.interpreter} $out/bin/lncrawler \
      --set PYTHONPATH "$PYTHONPATH:$out/share/lncrawl/" \
      --add-flags "$out/share/lncrawl/lncrawl"
    runHook postInstall
  '';

  desktopItems = desktopItem;

  meta = with lib; {
    homepage = "https://github.com/dipu-bd/lightnovel-crawler";
    description = "Generate and download e-books from online sources.";
    mainProgram = "lncrawler";
    license = licenses.mit;
    maintainers = with maintainers; [hans-chrstn];
    platforms = platforms.linux;
  };
}

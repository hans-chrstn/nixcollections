{
  lib,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  makeWrapper,
  fetchPypi,
  python311Packages,
}:
let 
  apps = import ./packages.nix { inherit fetchPypi python311Packages fetchFromGitHub; };
  desktopItem = makeDesktopItem {
    name = "lncrawl";
    exec = "lncrawl";
    desktopName = "lncrawl";
    icon = "";
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

  # dontBuild = true;
  # dontConfigure = true;
  dontStrip = true;
  # dontWrapGApps = true;

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
    # python311Packages.tk-tools
    # python311Packages.pyinstaller
    python311Packages.setuptools
    python311Packages.discordpy
    python311Packages.python-telegram-bot
    python311Packages.websockets
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/lncrawler/
    cp -r * $out/share/lncrawler/
    cat > $out/share/lncrawler/lncrawl.sh <<EOF
    #!/usr/bin/env bash
    mkdir -p ~/.lncrawl/sources
    for item in $out/share/lncrawler/*; do
      if [ "\$(basename "$\item")" == "sources" ]; then 
        continue
      fi
      ln -sf "\$item" ~/.lncrawl
    done
    cd ~/.lncrawl
    python3 -m lncrawl

    EOF
    chmod +x $out/share/lncrawler/lncrawl.sh

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/share/lncrawler/lncrawl.sh $out/bin/lncrawler \
    --add-flags $out/share/lncrawler/lncrawl/__init__.py \
    --set LD_LIBRARY_PATH ${lib.makeLibraryPath propagatedBuildInputs} \
    --prefix PATH : ${lib.makeBinPath propagatedBuildInputs} \
    --prefix PYTHONPATH : "$PYTHONPATH"
  '';


  desktopItems = desktopItem;

  meta = with lib; {
    homepage = "";
    description = "";
    mainProgram = "";
    license = licenses.mit;
    maintainers = with maintainers; [hans-chrstn];
    platforms = platforms.linux;
  };
}

{
  lib,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  python311Packages,
  python311Full,
  fetchPypi,
}:
let

  desktopItem = makeDesktopItem {
    name = "tuxemon";
    exec = "tuxemon";
    desktopName = "Tuxemon";
    icon = "tuxemon";
    categories = [];
  };

  pyscroll = python311Packages.buildPythonPackage rec {
    pname = "pyscroll";
    version = "2.31";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-GQIFGyCEN5/I22mfCgDSbV0g5o+Nw8RT316vOSsqbHA=";
    };
  };

  neteria = python311Packages.buildPythonPackage rec {
    pname = "neteria";
    version = "1.0.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Z/uCYGquDLEU1NsKKJ/QqE8xJl5tgT+i0HYbBVCP9Ks=";
    };
  };

  pygame_menu = python311Packages.buildPythonPackage rec {
    pname = "pygame-menu";
    version = "4.4.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-AqmeVXYB81bOLMgqEOmLy1gdU5pBxmbE7mFPrjZsNkc=";
    };
  };
in 
python311Packages.buildPythonPackage rec {
  pname = "tuxemon";
  version = "v0.4.34";

  src = fetchFromGitHub {
    owner = "Tuxemon";
    repo = "Tuxemon";
    rev = "v0.4.34";
    sha256 = "1xk16kflgm0sc9zhc5480nqm7rdnskz6wz7045rciabk61plmz19";
  };

  propagatedBuildInputs = [
    python311Packages.requests
    python311Packages.babel
    python311Packages.cbor
    neteria
    python311Packages.pillow
    python311Packages.pygame
    pyscroll
    python311Packages.pytmx
    python311Packages.requests
    python311Packages.natsort
    python311Packages.pyyaml
    python311Packages.prompt-toolkit
    pygame_menu
    python311Packages.pydantic_1
  ];

  nativeBuildInputs = [
    copyDesktopItems
    python311Packages.python
  ];

  format = "other";

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r * $out/share/
    mkdir -p $out/bin

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python311Full.interpreter} $out/bin/start \
      --set PYTHONPATH "$PYTHONPATH:$out/share/" \
      --add-flags "$out/share/run_tuxemon.py"
  '';

  desktopItems = [ ];

  meta = with lib; {
    homepage = "";
    description = "";
    mainProgram = "";
    license = licenses.mit;
    maintainers = with maintainers; [hans-chrstn];
    platforms = platforms.linux;
  };
}

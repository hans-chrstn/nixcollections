{
  lib,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
  fetchPypi,
}:
let

  desktopItem = makeDesktopItem {
    name = "tuxemon";
    exec = "";
    desktopName = "Tuxemon";
    icon = "tuxemon";
    categories = [];
  };

  pyscroll = python3Packages.buildPythonPackage rec {
    pname = "pyscroll";
    version = "2.31";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-GQIFGyCEN5/I22mfCgDSbV0g5o+Nw8RT316vOSsqbHA=";
    };
  };

  neteria = python3Packages.buildPythonPackage rec {
    pname = "neteria";
    version = "1.0.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Z/uCYGquDLEU1NsKKJ/QqE8xJl5tgT+i0HYbBVCP9Ks=";
    };
  };

  pygame_menu = python3Packages.buildPythonPackage rec {
    pname = "pygame-menu";
    version = "4.4.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-AqmeVXYB81bOLMgqEOmLy1gdU5pBxmbE7mFPrjZsNkc=";
    };
  };
in 
python3Packages.buildPythonPackage rec {
  pname = "tuxemon";
  version = "0.4.34";

  src = fetchFromGitHub {
    owner = "Tuxemon";
    repo = "Tuxemon";
    rev = "main";
    sha256 = "1xk16kflgm0sc9zhc5480nqm7rdnskz6wz7045rciabk61plmz19";
  };

  format = "other";

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];


  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out/bin/

    runHook postInstall
  '';

  propagatedBuildInputs = [
    python3Packages.requests
    python3Packages.babel
    python3Packages.cbor
    
    neteria
    python3Packages.pillow
    python3Packages.pygame
    pyscroll
    python3Packages.pytmx
    python3Packages.requests
    python3Packages.natsort
    python3Packages.pyyaml
    python3Packages.prompt-toolkit
    pygame_menu
    python3Packages.pydantic
  ];

  desktopItems = [ ];

  meta = with lib; {
    homepage = "";
    description = "";
    mainProgram = "";
    license = licenses.mit;
    maintainers = with maintainers; [hans-chrstn];
    platforms = [ "x86_64-linux" ];
  };
}

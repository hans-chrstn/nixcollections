{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libpulseaudio,
  makeDesktopItem,
  copyDesktopItems,
  unzip,
  pkg-config,
  libGL,
  libGLU,
  SDL2,
  xorg,
  python312Packages,
  makeWrapper,
}:
let
  desktopItem = makeDesktopItem {
    name = "openstarbound";
    exec = "openstarbound";
    icon = "openstarbound";
    desktopName = "OpenStarbound";
    categories = [ "Game" ];
  };
in
stdenv.mkDerivation rec {
  pname = "openstarbound";
  version = "v0.1.14";

  src = fetchurl {
    url = "https://github.com/OpenStarbound/OpenStarbound/releases/download/${version}/OpenStarbound-Linux-Clang-Client.zip";
    sha256 = "sha256-cqx18AfW8YGGqL5+48tK3JOW2MLUFHikKjHchnwp8u4=";
  };

  # icon = fetchurl {
  #   url = "https://avatars.githubusercontent.com/u/137134303?s=200&v=4";
  #   hash = "sha256-1fbycinjvh22qiv1xa898wmyphs7k6sxfvqxifnr7k87lc67iq5l";
  # };

  nativeBuildInputs = [
    makeWrapper
    unzip
    copyDesktopItems
  ];

  buildInputs = [
    pkg-config
    xorg.libXmu
    xorg.libXi
    xorg.libSM
    xorg.libICE
    xorg.libX11
    xorg.libXext
    libGL
    libGLU
    SDL2
    python312Packages.jinja2
    alsa-lib
    libpulseaudio
  ];

  dontStrip = true;
  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack
    unzip $src -d $PWD
    tar xvf *.tar -C $PWD
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r */* $out/bin

    cat > $out/bin/linux/run-client.sh <<EOF
#!/usr/bin/env sh

ulimit -n 65536

# User OpenStarbound folder
OPENSTARBOUND_DIR="\$HOME/.local/share/openstarbound"
mkdir -p "\$OPENSTARBOUND_DIR"

# Copy the binaries and assets on first run if needed
if [ ! -e "\$OPENSTARBOUND_DIR/linux/starbound" ]; then
    cp -r "$out/bin/linux" "\$OPENSTARBOUND_DIR/"
    cp -r "$out/bin/assets" "\$OPENSTARBOUND_DIR/"
fi

export SDL_VIDEODRIVER=x11

export SDL_AUDIODRIVER=pulseaudio

# Launch the game
cd "\$OPENSTARBOUND_DIR/linux"
LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:./" ./starbound "\$@"


EOF

    ls -l

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/bin/linux/run-client.sh $out/bin/${pname} \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath buildInputs}
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    homepage = "https://github.com/OpenStarbound/OpenStarbound";
    description = "";
    mainProgram = "openstarbound";
    license = licenses.mit;
    maintainers = with maintainers; [ hans-chrstn ];
    platforms = [ "x86_64-linux" ];
  };
}

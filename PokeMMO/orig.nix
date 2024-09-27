{
  lib,
  stdenv,
  fetchurl,
  libpulseaudio,
  alsa-lib,
  zulu,
  makeDesktopItem,
  glfw,
  openal,
  unzip,
  libglvnd,
  makeWrapper,
  gcc,
  copyDesktopItems,
}:
let
  desktopItem = makeDesktopItem {
    name = "pokemmo";
    exec = "pokemmo";
    icon = "pokemmo";
    desktopName = "PokeMMO";
    categories = [ "Game" ];
  };
in
stdenv.mkDerivation rec {
  pname = "pokemmo";
  version = "1.0";

  src = fetchurl {
    url = "https://dl.pokemmo.com/PokeMMO-Client.zip";
    hash = "sha256-RwerXrAX5dngIdfOxkNQIfxKuueMGq92enKqBmKOLnE=";
  };

  icon = fetchurl {
    url = "https://pokemmo.com/build/images/favicon.83823046.ico";
    hash = "sha256-MoR6eKuPppjT1oS9IWlCx/Uy/u7cwB7TvaeT9Z8AGK0=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip 
  ];

  buildInputs = [
    libpulseaudio
    alsa-lib
    zulu
    glfw
    openal
    libglvnd
    stdenv.cc.cc.lib
    gcc
  ];

  dontStrip = true;
  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack
    unzip $src || true
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out/bin

    cat > $out/bin/PokeMMO.sh <<EOF
    #!/usr/bin/env bash

    set -eqo pipefail

    os_flags=""

    case "uname" in
      Darwin* )
        # GLFW/LWJGL3 limitation for macOS
        os_flags="-XstartOnFirstThread"
        ;;
    esac

    mkdir -p ~/.local/share/pokemmo

    EXCLUDED_FOLDERS=("roms" "mods")
    for i in $out/bin/*; do
      base_name="\$(basename "\$i")"
      if [[ "\$base_name" != "log" && "\$base_name" != "config" && "\$base_name" != "roms" && "\$base_name" != "mods" ]]; then
          ln -sf "\$i" ~/.local/share/pokemmo/
      fi
    done

    cd ~/.local/share/pokemmo
    mkdir config
    touch config/main.properties
    
    [ ! -e config -o -L config ] && ln -sf $out/bin/config .

    # Launch PokeMMO
    java -Xmx384M \$os_flags -Dfile.encoding="UTF-8" -cp $out/bin/PokeMMO.exe com.pokeemu.client.Client

    EOF

    install -D $icon $out/share/icons/pokemmo.ico
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/bin/PokeMMO.sh $out/bin/${pname} \
      --add-flags $out/bin/PokeMMO.exe \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath buildInputs} \
      --prefix PATH : ${lib.makeBinPath [ zulu ]} \
      --set JAVA_HOME ${lib.getBin zulu}
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    homepage = "https://pokemmo.com";
    description = "PokeMMO";
    mainProgram = "pokemmo";
    license = licenses.unfree;
    maintainers = with maintainers; [ hans-chrstn ];
    platforms = [ "x86_64-linux" ];
  };
}

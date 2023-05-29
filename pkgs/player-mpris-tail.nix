{ fetchurl, stdenv, python3 }:
stdenv.mkDerivation rec {
  name = "player-mpris-tail";
  src = fetchurl {
    url =
      "https://raw.githubusercontent.com/polybar/polybar-scripts/a588bfc1191fe3f25da6b1a789eb017a505ac5bc/polybar-scripts/player-mpris-tail/player-mpris-tail.py";
    hash = "sha256-FTbU8dzUUVVYHFHPWa9Pjgyb7Amvf0c8gNRpf87YuMM=";
  };
  dontUnpack = true;
  buildInputs =
    [ (python3.withPackages (ps: with ps; [ pygobject3 dbus-python ])) ];
  installPhase = "install -Dm755 ${src} $out/bin/player-mpris-tail.py";
}

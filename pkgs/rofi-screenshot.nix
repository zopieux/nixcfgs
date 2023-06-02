{ lib, stdenv, fetchFromGitHub, makeWrapper, libnotify, slop, ffcast, ffmpeg
, xclip, rofi, coreutils, gnused, procps }:

stdenv.mkDerivation rec {
  pname = "rofi-screenshot";
  version = "2023-04-19";

  src = fetchFromGitHub {
    owner = "ceuk";
    repo = pname;
    rev = "a3e7f424de21b31003fc7b3c6b9e032088a24a53";
    hash = "sha256-r28rHeUI60c3z57MdK5s4FE5xQYtBX6CEl5+/bJ/rpc=";
  };

  patches = [ ./deps.patch ./out-directory.patch ];

  buildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --set PATH ${
        lib.makeBinPath [
          libnotify
          slop
          ffcast
          ffmpeg
          xclip
          rofi
          coreutils
          gnused
          procps
        ]
      }
  '';

  installPhase = ''
    install -Dm755 ${pname} $out/bin/${pname}
  '';

  meta = {
    description =
      "Use rofi to perform various types of screenshots and screen captures";
    homepage = "https://github.com/ceuk/rofi-screenshot";
    maintainers = with lib.maintainers; [ zopieux ];
    platforms = lib.platforms.all;
    license = lib.licenses.wtfpl;
  };
}

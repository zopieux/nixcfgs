{ lib, fetchurl, curl, appimageTools, runCommand }:
appimageTools.wrapType2 rec {
  name = "beeper";
  version = "3.57.10";

  src = fetchurl {
    url = "https://download.beeper.com/linux/appImage/x64";
    hash = "sha256-+g59ZQcZIWV3oE07QBINqaCIyQETabkBrlp4PZ9TrjU=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extractType2 { inherit name src; };
    installIcon = size: ''
      install -Dm644 ${appimageContents}/usr/share/icons/hicolor/${size}x${size}/apps/beeper.png \
        $out/share/icons/hicolor/${size}x${size}/apps/beeper.png
    '';
  in ''
    install -Dm444 ${appimageContents}/beeper.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/beeper.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=${name}'
    ${lib.concatMapStringsSep "\n" installIcon
    (map toString [ 16 32 48 64 128 256 512 1024 ])}
  '';

  meta = {
    homepage = "https://www.beeper.com/";
    description = "Unified chat app";
    longDescription = ''
      A single app to chat on iMessage, WhatsApp, and 13 other networks. You
      can search, prioritize, and mute messages. And with a unified inbox,
      you'll never miss a message again.
    '';
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}

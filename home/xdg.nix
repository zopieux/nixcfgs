{ config, lib, pkgs, ... }:

let
  browser = "google-chrome-stable";
  webApp = name: genericName: url: icon: {
    inherit name genericName;
    exec = ''${browser} --profile-directory=Default --app="${url}"'';
    terminal = false;
    categories = [ "Application" "WebBrowser" ];
    icon = (pkgs.fetchurl {
      url = icon.url;
      hash = icon.hash;
    }).outPath;
  };
in {
  xdg.desktopEntries = {
    chrome-glowing-bear =
      webApp "Glowing Bear" "IRC client" "https://irc.home.zopi.eu/" {
        url = "https://irc.home.zopi.eu/assets/img/glowing_bear_128x128.png";
        hash = "sha256-KAH6zKSQQl3Ga1TKU1GaJMlPebPPcOLIYt1srp/Hq5Y=";
      };

    chrome-element =
      webApp "Element" "Matrix client" "https://app.element.io/" {
        url =
          "https://raw.githubusercontent.com/vector-im/element-web/develop/res/vector-icons/120.png";
        hash = "sha256-AokJDNmzLnmGRoCRIbHiODK0iCtdyezWr2YBsXhTvC4=";
      };

    chrome-spotify =
      webApp "Spotify" "Online music player" "https://open.spotify.com/" {
        url = "https://open.spotifycdn.com/cdn/images/favicon.0f31d2ea.ico";
        hash = "sha256-DzHS6swU2eT/BGIhDRVUfL5nk10ycTuGBWKfD2z183g=";
      };

    chrome-youtube-music = webApp "Youtube Music" "Online music player"
      "https://music.youtube.com/" {
        url = "https://music.youtube.com/img/favicon_144.png";
        hash = "sha256-xuHQU1LBXb8ATf7uZ+Jz/xnASyzWlMkBfJgn6NjZz1Y=";
      };

    chrome-syncthing = webApp "Syncthing" "File synchronization daemon"
      "http://127.0.0.1:8384/" {
        url =
          "https://raw.githubusercontent.com/syncthing/syncthing/main/assets/logo-128.png";
        hash = "sha256-X4e1oiCEWGdOLqxX4WsU2yPnX7sjU08OvEhzfDXAr1k=";
      };

    chrome-alt = {
      name = "Alt";
      exec = ''${browser} --profile-directory="Profile 1"'';
      terminal = false;
      categories = [ "Application" "WebBrowser" ];
    };

    streamlink = {
      name = "streamlink";
      exec = "${pkgs.writeShellScript "streamlink" ''
        ${pkgs.streamlink}/bin/streamlink -p mpv $(${pkgs.rofi}/bin/rofi -dmenu -p "Link: ") best
      ''}";
    };
  };
}

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
        url =
          "https://raw.githubusercontent.com/glowing-bear/glowing-bear/b0675b1ad395023eeba9135d0c1d85102157c90e/src/assets/img/glowing_bear_128x128.png";
        hash = "sha256-KAH6zKSQQl3Ga1TKU1GaJMlPebPPcOLIYt1srp/Hq5Y=";
      };

    chrome-element =
      webApp "Element" "Matrix client" "https://app.element.io/" {
        url =
          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Element_%28software%29_logo.svg/54px-Element_%28software%29_logo.svg.png";
        hash = "sha256-MUA7cMTh6x5hUrsF2TvDpTSsofAwKFc17cINk1voYAI=";
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

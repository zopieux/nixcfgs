{ config, lib, pkgs, ... }:

let cfg = config.my.roles.graphical;
in {
  options = {
    my.roles.graphical.enable = lib.mkEnableOption "Graphical computer";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      i3
      konsole
      pavucontrol
      xorg.xkill
      xorg.xev
      gnome.adwaita-icon-theme
      vscode
      nixfmt
      google-chrome
      firefox
      mpv
      vlc
      feh
      evince
      imgurbash2
      audacity
      reaper
      gimp-with-plugins
      streamlink
      yt-dlp
    ];

    fonts.fonts = with pkgs; [
      (iosevka-bin.override { variant = "sgr-iosevka-fixed"; })
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka Fixed" "Noto Sans Mono" "Noto Sans Symbols" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols" ];
        serif = [ "Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols" ];
      };
    };

    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    # services.xserver.displayManager.lightdm.autoLogin.timeout = 2;
    services.xserver.displayManager.autoLogin.user = "alex";
    services.xserver.windowManager.i3.enable = true;

    hardware.opengl.enable = true;

    # Configure keymap in X11
    services.xserver.layout = "fr";
    services.xserver.xkbVariant = "oss";

    # dconf for programs that use GSettings.
    programs.dconf.enable = true;

    # Enable sound.
    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
    };

    # Enable NetworkManager applet
    programs.nm-applet.enable = true;

    # GVFS to mount MTP devices
    services.gvfs.enable = true;
  };
}

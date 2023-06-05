{ config, lib, pkgs, ... }:

let cfg = config.my.roles.graphical;
in {
  options = {
    my.roles.graphical.enable = lib.mkEnableOption "Graphical computer";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      anydesk
      audacity
      blender
      evince
      feh
      firefox
      gimp-with-plugins
      gist
      gnome.adwaita-icon-theme
      google-chrome
      i3
      imgurbash2
      keepassxc
      konsole
      libreoffice
      lxqt.lxqt-policykit
      mpv
      nixfmt
      pavucontrol
      reaper
      streamlink
      sxiv
      thunderbird
      upscayl
      vlc
      vscode
      xorg.xev
      xorg.xkill
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
      hinting.enable = false;
      defaultFonts = {
        monospace = [ "Iosevka Fixed" "Noto Sans Mono" "Noto Sans Symbols" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols" ];
        serif = [ "Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols" ];
      };
    };

    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
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
    services.gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };

    # Thumbnails.
    services.tumbler.enable = true;

    # i2c, e.g. for DDC monitor control.
    hardware.i2c.enable = true;
  };
}

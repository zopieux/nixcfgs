{ config, lib, pkgs, ... }:

let
  mod = "Mod4";
  alt = "Mod1";

  cfg = config.my.home.i3;
in {
  options = {
    my.home.i3 = { enable = lib.mkEnableOption "Enable i3 config"; };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.variety = {
      Unit.PartOf = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.variety}/bin/variety";
      Install.WantedBy = [ "graphical-session.target" ];
    };
    home.file.".config/variety/variety.conf" = {
      text = ''
        quotes_enabled = False
        clock_enabled = False
        copyto_enabled = False
        desired_color_enabled = False
        safe_mode = False
        change_on_start = False
        change_enabled = True
        change_interval = 3600
        internet_enabled = True
        use_landscape_enabled = True
        min_size_enabled = True
        min_size = 100
        icon = Light
        download_preference_ratio = 0.9
        set_wallpaper_script = ${
          pkgs.writeShellScript "set-wallpaper" ''
            ${pkgs.feh}/bin/feh --bg-fill "$1"
          ''
        }

        [sources]
        src9 = True|unsplash|High-resolution photos from Unsplash.com
      '';
    };

    xsession.windowManager.i3 = {
      enable = true;
      config = let
        pactl = "${pkgs.pulseaudio}/bin/pactl";
        rofi = "${pkgs.rofi}/bin/rofi";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      in {
        modifier = mod;
        floating.modifier = mod;
        focus.followMouse = false;
        focus.mouseWarping = false;
        focus.wrapping = "no";
        terminal = "konsole";
        fonts = {
          names = [ "monospace" ];
          size = 10.0;
        };
        startup = [
          {
            command = "systemctl --user restart polybar";
            always = true;
            notification = false;
          }
          {
            command = "systemctl --user restart variety";
            always = true;
            notification = false;
          }
        ];
        window.commands = [{
          criteria.class = "(?i)File Operation Progress";
          command = "floating enable";
        }];
        keybindings = lib.mkOptionDefault {
          "${mod}+d" = ''
            exec --no-startup-id "${rofi} -modi drun -show drun -show-icons -drun-match-fields name,generic,exec,keywords -drun-display-format \\"{name} <tt>{exec}</tt>\\""
          '';
          "${mod}+Tab" =
            "exec --no-startup-id ${rofi} -modi window -show window";
          "${mod}+Pause" = ''
            exec --no-startup-id ${rofi} -show p -modi "p:${pkgs.rofi-power-menu}/bin/rofi-power-menu --choices=shutdown/reboot/logout"'';
          "${mod}+semicolon" =
            "exec --no-startup-id ${pkgs.rofimoji}/bin/rofimoji";
          "${mod}+e" = "exec ${pkgs.xfce.thunar}/bin/thunar";

          # Moves
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";
          "${mod}+${alt}+Left" = "move left";
          "${mod}+${alt}+Down" = "move down";
          "${mod}+${alt}+Up" = "move up";
          "${mod}+${alt}+Right" = "move right";
          "${mod}+Ctrl+Left" = "move container to output left";
          "${mod}+Ctrl+Down" = "move container to output down";
          "${mod}+Ctrl+Up" = "move container to output up";
          "${mod}+Ctrl+Right" = "move container to output right";
          "${mod}+Shift+Left" = "move workspace to output left";
          "${mod}+Shift+Right" = "move workspace to output right";
          "${mod}+h" = "split h";
          "${mod}+v" = "split v";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Shift+f" = "fullscreen toggle global";
          "${mod}+t" = "layout tabbed";
          "${mod}+y" = "layout stacking";
          "${mod}+u" = "layout toggle split";
          "${mod}+q" = "focus parent";
          "${mod}+s" = "focus child";
          "${mod}+w" = "kill";
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";

          # Scratchpad
          "${mod}+n" = "scratchpad show";
          "${mod}+Shift+n" = "move scratchpad";

          # Volume
          "${mod}+Shift+p" = "exec pavucontrol";
          "XF86AudioRaiseVolume" =
            "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" =
            "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" =
            "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" =
            "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";

          # Player control with MPRIS D-Bus
          "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";
          "XF86AudioStop" = "exec --no-startup-id ${playerctl} stop";
          "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";
          "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
        };
        bars = [ ];
      };
    };

    services.polybar = {
      enable = true;
      script = ''
        polybar left &
        polybar right &
      '';
      package = pkgs.polybar.override {
        i3Support = true;
        pulseSupport = true;
      };
      settings = {
        "colors" = {
          #[aa]rrggbb
          background = "#c0000000";
          foreground = "#eaeaea";
          muted = "#80eaeaea";
          highlight = "#4c7899";
          warning = "#ff3121";
          focused = "#cc5c00";
          transparent = "#00000000";
        };

        "settings" = { screenchange-reload = false; };

        "bar/common" = {
          bottom = true;
          width = "100%";
          height = 22;
          offset-x = 0;
          offset-y = 0;
          background = "\${colors.background}";
          foreground = "\${colors.foreground}";
          font-0 = "monospace:pixelsize=10:weight=bold;2";
          # https://www.nerdfonts.com/cheat-sheet
          font-1 = "Symbols Nerd Font:pixelsize=10;1";
          font-2 = "Symbols Nerd Font:pixelsize=10:antialias=false;1";
          line-size = 2;
          line-color = "#f00";
          spacing = 0;
          padding-right = 1;
          module-margin = 1;
          modules-left = "i3";
          modules-center = "now-playing date";
          modules-right = "net-lan temp cpu memory fs pulseaudio";
        };

        "bar/left" = {
          monitor = "DP-4";
          "inherit" = "bar/common";
        };
        "bar/right" = {
          "inherit" = "bar/common";
          monitor = "HDMI-0";
          tray-position = "right";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 0.5;
          format = "<label> <ramp-coreload>";
          ramp-coreload-spacing = 0;
          ramp-coreload-0 = "▁";
          ramp-coreload-0-foreground = "#aaff77";
          ramp-coreload-1 = "▂";
          ramp-coreload-1-foreground = "#aaff77";
          ramp-coreload-2 = "▃";
          ramp-coreload-2-foreground = "#aaff77";
          ramp-coreload-3 = "▄";
          ramp-coreload-3-foreground = "#aaff77";
          ramp-coreload-4 = "▅";
          ramp-coreload-4-foreground = "#fba922";
          ramp-coreload-5 = "▆";
          ramp-coreload-5-foreground = "#fba922";
          ramp-coreload-6 = "▇";
          ramp-coreload-6-foreground = "#ff5555";
          ramp-coreload-7 = "█";
          ramp-coreload-7-foreground = "#ff5555";
        };

        "module/memory" = {
          type = "internal/memory";
          format = "<label> <bar-used>";
          label = "RAM";
          bar-used-width = 9;
          bar-used-foreground-0 = "#aaff77";
          bar-used-foreground-1 = "#aaff77";
          bar-used-foreground-2 = "#fba922";
          bar-used-foreground-3 = "#ff5555";
          bar-used-indicator = "━";
          bar-used-indicator-foreground = "#ff";
          bar-used-fill = "━";
          bar-used-empty = "━";
          bar-used-empty-foreground = "#50ffffff";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state><label-mode>";
          index-sort = true;
          wrapping-scroll = false;
          strip-wsnumbers = true;
          pin-workspaces = true;
          label-focused = "%name%%icon%";
          label-focused-underline = "#89a6d4";
          label-focused-padding = 1;
          label-visible = "%name%%icon%";
          label-visible-underline = "#89a6d4";
          label-visible-padding = 1;
          label-unfocused = "%name%%icon%";
          label-unfocused-padding = 1;
          label-urgent = "%name%%icon%";
          label-urgent-underline = "#935555";
          label-urgent-background = "#650d0d";
          label-urgent-padding = 1;
          ws-icon-0 = "8; ";
          ws-icon-1 = "9; ";
          ws-icon-2 = "10; ♫";
        };

        "module/net-lan" = {
          type = "internal/network";
          interface = "enp14s0";
          interval = 3.0;
          ping-interval = 10;
          format-connected = "<label-connected>";
          label-connected = "%downspeed:8% %{T2}%{T-} %upspeed:8% %{T2}%{T-}";
          label-disconnected-foreground = "\${colors.muted}";
        };

        "module/fs" = {
          type = "internal/fs";
          mount-0 = "/";
          interval = 5;
          fixed-values = true;
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;
          date =
            "%{T3}󰃮%{T-} %%{F#999}%Y-%m-%{F#4BA09C}%d%%{F#999} ⋅ %%{F#F6EFC4}%H%{F#999}:%{F-}%{F#C59A7B}%M%{F#999}:%S%%{F-}";
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          format-volume = "<ramp-volume><label-volume>";
          label-volume = "%percentage:3%%";
          format-muted = "<label-muted>";
          label-muted = "%{F#80eaeaea}󰝟 –— ";
          ramp-volume-0 = "󰕿";
          ramp-volume-1 = "󰖀";
          ramp-volume-2 = "󰕾";
          click-right = "pavucontrol";
        };

        "module/temp" = {
          type = "internal/temperature";
          hwmon-path =
            "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1/temp1_input";
          interval = 2;
          warn-temperature = 70;
          label-warn-foreground = "\${colors.warning}";
        };

        "module/now-playing" = {
          type = "custom/script";
          tail = true;
          exec =
            "${pkgs.player-mpris-tail}/bin/player-mpris-tail.py --icon-playing '󰎈' --icon-paused '󰎊' --icon-stopped '' -w chromium -w Spot -f '{icon} {artist} ⋅ {title}'";
        };
      };
    };

    programs.rofi = {
      enable = true;
      extraConfig = { show-icons = true; };
      theme = ./source/rofi-theme.rasi;
    };
  };
}

{ name, config, pkgs, ... }:

let my = import ../..;
in {
  imports = [ my.modules ./hardware.nix ];

  deployment.targetHost = "192.168.1.30";

  my.roles.gaming.enable = true;
  my.roles.graphical.enable = true;
  my.roles.nvidia.enable = true;
  my.roles.nvidia.enableCuda = true;

  environment.systemPackages = with pkgs; [ beeper ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";

  nixpkgs.config.cudaCapabilities = [ "5.0" "5.2" "5.3" ];

  home-manager.users."alex" = {
    services.syncthing = {
      enable = true;
      tray.enable = true;
    };

    programs.autorandr = {
      enable = true;
      profiles.dual = {
        hooks.postswitch = "${pkgs.i3}/bin/i3-msg reload";
        fingerprint = {
          DP-4 =
            "00ffffffffffff0010acd1a051415230021a0104a53c227806ee91a3544c99260f505421080001010101010101010101010101010101565e00a0a0a029503020350056502100001a000000ff002341534d4656306a6a4f372f64000000fd001e9022d139010a202020202020000000fc0044656c6c20533237313644470a018f020312412309070183010000654b040001015a8700a0a0a03b503020350056502100001a5aa000a0a0a046503020350056502100001a6fc200a0a0a055503020350056502100001a8fde00a0a0a00f503020350056502100001e1c2500a0a0a011503020350056502100001a0000000000000000000000000000000000000098";
          HDMI-0 =
            "00ffffffffffff0009d1d678455400001a1b0103803c2278260cd5a9554ca1250d5054a56b80818081c08100a9c0b300d1c001010101565e00a0a0a029503020350055502100001a000000ff0057364830303332343031390a20000000fd00324c1e591b000a202020202020000000fc0042656e51204757323736350a2001f1020323f14f901f05140413031207161501061102230907078301000066030c00100038023a801871382d40582c450056502100001f011d8018711c1620582c250056502100009f011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e960056502100001800000000000000000000000000000000000000000d";
        };
        config = {
          DP-4 = {
            enable = true;
            position = "0x0";
            mode = "2560x1440";
            rate = "60.00";
          };
          HDMI-0 = {
            enable = true;
            primary = true;
            position = "2560x0";
            mode = "2560x1440";
            rate = "60.00";
          };
        };
      };
    };
  };
}

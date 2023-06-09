{ config, lib, pkgs, ... }:

let cfg = config.my.home.graphical;
in {
  options = {
    my.home.graphical.enable = lib.mkEnableOption "Graphical machine";
  };

  config = lib.mkIf cfg.enable {
    my.home.i3.enable = true;
    my.home.xcompose.enable = true;

    xsession.numlock.enable = true;
  };
}

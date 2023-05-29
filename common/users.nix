{ pkgs, config, ... }:

let
  my = import ./..;
  self = "alex";
in rec {
  users.users."${self}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "mlocate" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5oGmMmhEp/FT77b8KdMSYl4xTcbm10btUP0QIA1/0U"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys =
      users.users."${self}".openssh.authorizedKeys.keys;
  };

  security.sudo.extraRules = [{
    users = [ self ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  home-manager.users."${self}" = {
    imports = [ my.home ];

    # TODO: make that automatic for all users.
    config = {
      my.home.graphical.enable = config.my.roles.graphical.enable;
      # my.home.laptop.enable = config.my.roles.laptop.enable;
    };
  };
}

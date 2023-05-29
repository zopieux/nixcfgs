{ config, pkgs, ... }:

{
  home.username = "alex";
  home.homeDirectory = "/home/alex";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  programs.command-not-found.enable = true;

  programs.bat = {
    enable = true;
    config = { style = "plain"; };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  imports = [
    ./git.nix
    ./graphical.nix
    ./i3.nix
    ./mercurial.nix
    ./ssh.nix
    ./tmux.nix
    ./vscode.nix
    ./xcompose.nix
    ./xdg.nix
    ./zsh.nix
    # ./laptop.nix
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];
}

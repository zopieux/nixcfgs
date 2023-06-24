{ config, pkgs, ... }:

{
  home.username = "alex";
  home.homeDirectory = "/home/alex";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.sessionVariables = { NIX_AUTO_RUN = "1"; };

  programs.bat = {
    enable = true;
    config = { style = "plain"; };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Hint that we prefer a dark theme.
  gtk.theme.name = "Adwaita Dark";

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

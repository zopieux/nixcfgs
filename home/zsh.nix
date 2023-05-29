{ config, pkgs, ... }:

{
  config = {
    programs.zsh = {
      enable = true;
      enableSyntaxHighlighting = true;
      initExtraFirst = ''
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      '';

      shellAliases = { ip = "ip --color=auto"; };

      initExtra = ''
        # Bind Alt+m to copy the previous word.
        autoload -Uz copy-earlier-word
        zle -N copy-earlier-word
        bindkey "^[m" copy-earlier-word

        # Disable stupid ^S and ^Q freeze
        stty -ixon
      '';
    };
  };
}

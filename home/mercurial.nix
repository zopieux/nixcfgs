{ config, ... }:

{
  config.programs.mercurial = {
    enable = true;
    userName = "Alexandre Macabies";
    userEmail = "web+oss@zopieux.com";
    extraConfig = {
      ui = { verbose = true; };
      extensions = {
        color = "";
        fetch = "";
        hgk = "";
        histedit = "";
        mq = "";
        rebase = "";
      };
    };
  };
}

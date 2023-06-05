{ config, ... }:

{
  config.programs.git = {
    enable = true;
    userName = "Alexandre Macabies";
    userEmail = "web+oss@zopieux.com";

    aliases = {
      graph = "log --all --graph --decorate --abbrev-commit --pretty=oneline";
    };

    lfs.enable = true;

    extraConfig = {
      pull.rebase = true;
      push.followTags = true;
      push.autoSetupRemote = true;
      merge.ff = "only";
      rebase.autostash = true;
      branch.autosetuprebase = "always";
      init.defaultBranch = "master";

      fetch = {
        recursesubmodules = true;
        prune = true;
        prunetags = true;
      };

      color = {
        branch = "auto";
        diff = "auto";
        status = "auto";
      };

      "color \"branch\"" = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };
      "color \"diff\"" = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };
      "color \"status\"" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };

      diff = {
        png = {
          textconv = "identify -verbose";
          binary = true;
        };
      };

      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };

    ignores = [
      "*.aux"
      "*.ipynb"
      "*.log"
      "*.pyc"
      ".*.swp"
      ".direnv/"
      "result"
      "result/"
      ".syntastic_cpp_config"
      "__pycache__/"
      "pip-wheel-metadata"
    ];
  };
}

{ name, lib, config, pkgs, ... }:

{
  networking.hostName = name;

  networking.extraHosts = ''
    192.168.1.1   router
    192.168.1.10  nas
    192.168.1.20  desktop
    192.168.1.30  desktop2k
    192.168.1.40  tv
  '';

  environment.systemPackages = with pkgs; [
    aria2
    binutils
    colmena
    curl
    dig
    ffmpeg
    file
    gdb
    git
    glances
    gnumake
    htop
    jq
    moreutils
    mosh
    ncdu
    p7zip
    pciutils
    python3
    reptyr
    ripgrep
    tree
    unrar
    unzip
    usbutils
    vim_configurable
    wget
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "boot.shell_on_fail" ];

  security.sudo.enable = true;

  programs.less.enable = true;
  programs.vim.defaultEditor = true;

  # Zsh
  programs.zsh.enable = true;
  programs.autojump.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  # Auto-run missing binaries.
  environment.variables.NIX_AUTO_RUN = "1";
  programs.command-not-found.enable = true;
  programs.command-not-found.dbPath = let
    channelTarball = pkgs.fetchurl {
      url =
        "https://releases.nixos.org/nixos/unstable/nixos-23.11pre494976.7c67f006ea0/nixexprs.tar.xz";
      hash = "sha256-4QcIW34X2AwIIfZSrDnz7BcAlLH7FhHa38QTHWeY0qU=";
    };
  in pkgs.runCommand "programs.sqlite" { } ''
    tar xf ${channelTarball} --wildcards "nixos*/programs.sqlite" -O > $out
  '';

  # SUID wrappers
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; };
  programs.ssh.startAgent = true;

  # Services
  services.openssh.enable = true;
}

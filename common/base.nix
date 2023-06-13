{ name, config, pkgs, ... }:

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

  # SUID wrappers
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; };
  programs.ssh.startAgent = true;

  # Services
  services.openssh.enable = true;
}

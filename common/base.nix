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
    pciutils
    usbutils
    binutils
    file
    tree
    python3
    moreutils
    dig
    reptyr
    git
    git-lfs
    wget
    curl
    htop
    mosh
    unzip
    unrar
    p7zip
    ffmpeg
    gnumake
    jq
    colmena
    vim_configurable
    gdb
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

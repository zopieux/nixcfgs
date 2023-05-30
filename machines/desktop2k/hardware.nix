{ config, lib, pkgs, modulesPath, ... }:

rec {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2220839d-d04c-4081-a776-60e0ba1d08f5";
    fsType = "ext4";
  };
  fileSystems."${boot.loader.efi.efiSysMountPoint}" = {
    device = "/dev/disk/by-uuid/6ACD-8570";
    fsType = "vfat";
  };

  boot.tmp.useTmpfs = true;

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "conservative";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;
}

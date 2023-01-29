{ config, lib, pkgs, cfg, modulesPath, attrs, ... }:

{
  imports = [
    ./laptop.nix
    "${modulesPath}/installer/scan/not-detected.nix"
    attrs.home-manager.nixosModule

    ../base/pipewire.nix
    ../base/wg.nix
  ];

  networking = {
    hostName = "lap";
    hostId = "4f82f319";
  };

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "ums_realtek" "sd_mod" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  services = {
    logind.lidSwitch = "suspend";
    zfs.trim.enable = true;
    xserver.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/nix" = {
      device = "rpool/root/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home" = {
      device = "rpool/root/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6C4B-FD89";
      fsType = "vfat";
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  home-manager.users.${cfg.user} = {
    imports = [ ../home_manager/home.nix ];
  };

  programs.evolution = {
    enable  = true;
    plugins = [ pkgs.evolution-ews ];
  };

  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable         = true;
    gnome-online-accounts.enable = true;
  };
}
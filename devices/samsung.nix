{ config, lib, pkgs, cfg, ... }:

{
  imports = [
    ./laptop.nix
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  networking = {
    hostName = "sam";
    hostId = "97e8239a";
  };

  boot = {
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
      device = "rpool/nixos";
      fsType = "zfs";
    };

    "/nix" = {
      device = "rpool/nixos/nix";
      fsType = "zfs";
    };

    "/home" = {
      device = "rpool/nixos/home";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/EA5D-D4D2";
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
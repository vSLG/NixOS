{ config, lib, pkgs, cfg, ... }:

{
  imports = [
    ../base/common.nix
  ];

  networking.networkmanager.wifi = {
    scanRandMacAddress = true;
    macAddress = "random";
    backend = "wpa_supplicant";
  };

  hardware = {
    enableRedistributableFirmware = true; # WiFi
    bluetooth.enable              = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "modesetting" ];

      synaptics = {
        enable          = true;
        twoFingerScroll = true;
        fingersMap      = [ 1 3 2 ];
        palmDetect      = true;
      };

      displayManager.sddm.enable = true;
      displayManager.autoLogin.user = cfg.user;

      desktopManager.xterm.enable   = false;
      displayManager.defaultSession = "home-manager";

      desktopManager.session = [
        {
          name = "home-manager";
          start = ''
            ${pkgs.runtimeShell} $HOME/.xsession &
            waitPID=$!
          '';
        }
      ];
    };

    redshift = {
      enable = true;
      temperature = {
        day   = 6000;
        night = 3700;
      };
    };

    # Removable media automount
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;

    blueman.enable = true;
  };

  programs = {
    light.enable = true;
    dconf.enable = true;
    adb.enable = true;
  };

  users.users.${cfg.user}.extraGroups = [
    "scanner" "lp" "libvirtd" "kvm" "docker" "lxd" "plugdev"
    "adbusers"
  ];
}

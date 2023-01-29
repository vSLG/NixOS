{ config, lib, pkgs, cfg, ... }:

{
  imports = [ ./location.nix ];
  
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # WireGuard
  networking.firewall = {
    enable          = true;
    allowedUDPPorts = [
      51820 # Wireguard
      54911 # Torrent
      5432  # Random
    ];
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = lib.mkDefault "no";
      # passwordAuthentication = false;
      # kbdInteractiveAuthentication = false;
    };

    xserver = {
      layout = "br";
      xkbVariant = "nativo";
    };

    redshift = {
      enable = true;
      temperature = {
        day   = 6000;
        night = 3700;
      };
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  networking = {
    networkmanager.enable = true;
  };

  console = {
    font         = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs = {
    zsh = {
      enable                    = true;
      syntaxHighlighting.enable = true;
    };
  };

  users.users.${cfg.user} = {
    isNormalUser = true;
    extraGroups  = [
      "wheel"
      "video"
      "audio"
      "input"
      "dialout"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    group = cfg.user;
    initialHashedPassword = "$6$6zvPoYmIpgOhcGZw$mXeLwUP044HHJtpHIfycGuHLBKD6kZFjYX58FlNunlbXVP6mr5lXs.P0jm.SUK4UayzhCgPzM38vDS08YvwGf.";
  };

  users.groups.${cfg.user}.gid = 1000;

  nix = {
    package = pkgs.nixFlakes;

    settings = {
      auto-optimise-store = true; # NixOS 22.11
      experimental-features = [ "nix-command" "flakes" ];
      # settings.cores = 5;
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # System
    neovim htop exa fd ripgrep tmux htop wget curl ncdu cryptsetup
    unrar p7zip bat git ntfs3g pciutils zfs
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
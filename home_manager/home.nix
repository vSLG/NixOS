{ config, pkgs, ...}:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "j";
  home.homeDirectory = "/home/j";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Comm
    mumble tdesktop gajim discord mirage-im
    filezilla qbittorrent drive mariadb-client minicom usbutils

    # Media
    mpv vlc pamixer playerctl obs-studio hydrus

    # Desktop
    pcmanfm viewnior xfce.mousepad qutebrowser
    kitty pavucontrol qpdfview xournalpp
    gnome3.adwaita-icon-theme gimp firefox qMasterPassword
    xboxdrv krita minetest libreoffice # spectre-cli
    maim xclip xdotool feh polybar font-awesome siji

    # Misc
    libqalculate neofetch wineWowPackages.staging
    virt-manager prismlauncher openjdk8 unzip jq

    # Dev
    delta ccls poetry

    # LaTeX
    texstudio texlive.combined.scheme-full

  ];

  # Services
  # services.gnome-keyring.enable = true;
  # services.gpg-agent.enable     = true;
  fonts.fontconfig.enable = true;

  programs.direnv = {
    enable                  = true;
    enableZshIntegration    = true;
    nix-direnv.enable       = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      golang.go
      redhat.java
      llvm-vs-code-extensions.vscode-clangd
      bbenoist.nix brettm12345.nixfmt-vscode jnoortheen.nix-ide
    ];
  };

  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  ];

  home.file.".direnv-hack".text = ''
    eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
  '';

  xsession.profileExtra = ''
    dbus-update-activation-environment --systemd --all
  '';

  # xsession.scriptPath = ".hm-xsession";

  imports = [ ./i3-gaps.nix ./polybar.nix ];
}

{ config, lib, pkgs, ... }:

let
  mod = "Mod4";
in {
  xsession.enable = true;

  qt.enable     = true;
  qt.style.name = "adwaita.dark";

  gtk = {
    enable = true;
    theme  = {
      package = pkgs.theme-obsidian2;
      name    = "Obsidian-2-Teal";
    };

    iconTheme = {
      package = pkgs.faba-icon-theme;
      name    = "Faba";
    };

    font = {
      size = 12;
      name = "Roboto Regular";
    };
  };

  xsession.windowManager.i3 = {
    enable  = true;
    package = pkgs.i3-gaps;

    config = {
      modifier    = mod;
      keybindings = {};
      bars = [];

      fonts = {
        names = [ "HackGen Console" "Roboto Regular" ];
        size = 14.0;
      };

      window = {
        border = 4;
      };

      gaps = {
        inner        = 4;
        outer        = 8;
        top          = 52;
        smartBorders = "on";
        # smartGaps    = true;
      };

      workspaceAutoBackAndForth = true;

      assigns = {
        "1" = [
          { class = "Telegram"; }
          { class = "mirage"; }
          { class = "Gajim"; }
        ];
        "2" = [
          { class = "firefox"; }
          { class = "qutebrowser"; }
        ];
        "3" = [
          { class = "evolution"; }
        ];
        "8" = [
          { class = "QjackCtl"; }
          { class = "(C|c)alfjackhost"; }
        ];
      };

      floating = {
        border = 4;

        criteria = [
          { class = "Pavucontrol"; }
          { class = "TelegramDesktop"; title = "^(?!Telegram)"; }
          { class = "qMasterPassword"; }
          { class = "QjackCtl"; }
          { class = "(C|c)alfjackhost"; }
        ];
      };

      focus = {
        followMouse = true;
        newWindow   = "focus";
      };

      startup = [
        { command = "${pkgs.feh}/bin/feh --bg-fill /home/j/Pictures/wallpaper/a0e0f153d56e9e766cc70e90b8cdc4bd.png"; always = true; notification = false; }
        { command = "${pkgs.qutebrowser}/bin/qutebrowser"; }
        { command = "${pkgs.firefox}/bin/firefox"; }
        { command = "${pkgs.tdesktop}/bin/telegram-desktop"; }
        # { command = "${pkgs.mirage-im}/bin/mirage"; }
        { command = "${pkgs.gajim}/bin/gajim"; }
        { command = "${pkgs.calf}/bin/calfjackhost -l /home/j/documents/calf"; }
        { command = "${pkgs.qjackctl}/bin/qjackctl"; }
        { command = "${pkgs.evolution}/bin/evolution"; }
      ];
    };
  };

  services.sxhkd = {
    enable = true;
    extraOptions =  [ "-m -1" ];

    keybindings = {
      "super + {_, shift +} Return" = "${pkgs.kitty}/bin/kitty {tmux,_}";                                                                                                  
      "super + a"                   = "${pkgs.rofi}/bin/rofi -show run";                                                                                                   
      "super + Escape"              = "pkill -USR1 -x sxhkd";                                                                                                              
                                                                                                                                                                           
      "super + {_,shift + }{d,s,r,n}" = "i3-msg {focus,move container to }{left,up,down,right}";                                                                           
      "super + {1-9}"                 = "i3-msg workspace number {1-9}";                                                                                                   
      "super + shift + {1-9}"         = "i3-msg move container to workspace number {1-9}, workspace {1-9}";                                                                
                                                                                                                                                                           
      "super + {_,shift +} h"     = "i3-msg {mode resize,restart}";                                                                                                        
      "super + b"                 = "i3-msg split v";                                                                                                                      
      "super + m"                 = "i3-msg split h";                                                                                                                      
      "super + period"            = "i3-msg layout toggle split";                                                                                                          
      "super + o"                 = "i3-msg fullscreen toggle";                                                                                                            
      "super + comma"             = "i3-msg layout tabbed";                                                                                                                
      "super + e"                 = "i3-msg layout stacking";                                                                                                              
      "super + slash"             = "i3-msg kill";                                                                                                                         
      "super + {_,shift +} space" = "i3-msg {focus mode_,floating }toggle";                                                                                                
      "super + l"                 = "${pkgs.xscreensaver}/bin/xscreensaver-command -lock";                                                                                 
      "shift + @Print"            = "/home/j/.local/bin/screenshot.sh area";                                                                                               
      "super + @Print"            = "/home/j/.local/bin/screenshot.sh active";                                                                                             
      "@Print"                    = "/home/j/.local/bin/screenshot.sh";                                                                                                    
      "super + j"                 = "/home/j/.local/bin/rofi-stickers";

      "super + F1" = "${pkgs.mirage-im}/bin/mirage";
      "super + F2" = "${pkgs.qutebrowser}/bin/qutebrowser";
      "super + F3" = "${pkgs.pcmanfm}/bin/pcmanfm";

      "XF86MonBrightness{Up,Down}"   = "${pkgs.light}/bin/light {-A,-U} 5";
      "XF86Audio{Raise,Lower}Volume" = "${pkgs.pamixer}/bin/pamixer {-i,-d} 5";
      "XF86AudioMute"                = "${pkgs.pamixer}/bin/pamixer -t";
      "XF86AudioPlay"                = "${pkgs.playerctl}/bin/playerctl play-pause";
    };
  };

  services.picom = {
    enable = true;

    backend              = "glx";
    # experimentalBackends = true;

    # blur = true;

    fade      = true;
    fadeSteps = [ 0.03 0.03 ];
    fadeDelta = 5;

    # inactiveDim     = "0.3";
    inactiveOpacity = 0.8;

    shadow        = true;
    shadowExclude = [ "window_type *= 'menu'" ];
    shadowOpacity = 0.8;
  };

  services.xscreensaver = {
    enable   = true;
    settings = {
      dpmsEnabled = false;
      unfade      = false;
      fade        = true;
      fadeTicks   = 20;
      fadeSeconds = "0:00:05";
      timeout     = "0:10:00";
      lockTimeout = "0:01:00";
    };
  };

  # TODO: get main config from PC
  services.dunst = {
    enable = true;
  };

  services.playerctld = {
    enable  = true;
    package = pkgs.playerctl;
  };

  i18n.inputMethod = {
    enabled       = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };
}

{ config, lib, pkgs, ... }:

let
  background     = "#CC282A2E";
  background-alt = "#373B41";
  foreground     = "#C5C8C6";
  primary        = "#CBAA94";
  secondary      = "#BBCFE5";
  alert          = "#A54242";
  disabled       = "#707880";
in {
  services.polybar = {
    enable = true;

    script = "polybar main &";

    settings = {
      "bar/main" = {
        monitor = "\${env:MONITOR:eDP-1}";
        width = "1896px";
        height = "32px";

        background = background;
        foreground = foreground;

        # line-size = "2px";
        border-size = "4px";
        border-color = secondary;
        # radius = 6;
        offset-y = "8px";
        offset-x = "12px";

        padding-left = 0;
        padding-right = 0;

        module-margin = 1;

        separator = "|";
        separator-foreground = disabled;

        font-0 = "HackGen Console; 2";
        font-1 = "Font Awesome 6 Free:style=Regular; 3";
        font-2 = "Font Awesome 6 Free:style=Solid; 3";
        font-3 = "Font Awesome 6 Brands:style=Regular; 3";

        modules-left = "xworkspaces";
        modules-center = "xwindow";
        modules-right = "backlight memory cpu wlan eth battery date";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = true;

        tray-position = "right";

        override-redirect = true;
        wm-restack = "i3";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = background-alt;
        label-active-underline = primary;
        label-active-padding = 1;

        label-occupied = "%name%";
        label-occupied-padding = 1;
        label-urgent = "%name%";
        label-urgent-background = alert;
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-foreground = disabled;
        label-empty-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = primary;
        label = "%percentage:2%%";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = primary;
        label = "%percentage_used:2%%";
      };

      "network-base" = {
        type = "internal/network";
        interval = 2;
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";

        label-disconnected = "disconnected";
        label-disconnected-foreground = alert;
      };

      "module/wlan" = {
        "inherit" = "network-base";
        interface-type = "wireless";

        format-connected = "<label-connected> <ramp-signal>";

        ramp.signal = [ "" "" "" "" "" ];

        label-connected = "%essid%";
        label-connected-foreground = primary;
      };

      "module/eth" = {
        "inherit" = "network-base";
        interface-type = "wired";
        label-connected = "%{F" + primary +"}%ifname%%{F-} %local_ip%";
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;

        date = "%H:%M";
        date-alt = "%Y-%m-%d %H:%M:%S";

        label = "%date%";
      };

      "module/backlight" = {
        type = "internal/backlight";
        card = "intel_backlight";
        use-actual-brightness = true;
        enable-scroll = true;

        format = "<label>";
        format-prefix = " ";
        format-prefix-foreground = primary;
      };

      "module/battery" = {
        type = "internal/battery";
        full-at = 100;
        low-at = 15;
        battery = "BAT0";
        adapter = "AC";
        poll-interval = 5;

        time-format = "%H:%M";

        format-charging = "<animation-charging> <label-charging>";
        format-charging-foreground = "#50C200";
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-foreground = "#F4A900";
        format-low = "<ramp-capacity> <label-low>";
        format-low-foreground = alert;
        format-full = "<ramp-capacity> <label-full>";
        format-full-foreground = foreground;

        label-charging = "%percentage%%";
        label-discharging = "%percentage%%";
        label-low = "%percentage%% LOW";
        label-full = "%percentage%% FULL";

        animation.charging = [ "" "" "" "" "" ];
        animation-charging-framerate = 750;

        ramp.capacity = [ "" "" "" "" "" ];
      };
    };
  };
}

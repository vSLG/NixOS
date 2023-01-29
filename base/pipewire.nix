{ config, lib, pkgs, ...}:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];

    config.pipewire = {
      "context.modules" = [
        { name = "libpipewire-module-protocol-native"; }
        { name = "libpipewire-module-profiler"; }
        { name = "libpipewire-module-metadata"; }
        { name = "libpipewire-module-spa-device-factory"; }
        { name = "libpipewire-module-spa-node-factory"; }
        { name = "libpipewire-module-client-node"; }
        { name = "libpipewire-module-client-device"; }
        { name = "libpipewire-module-portal"; flags = [ "ifexists" "nofail" ]; }
        { name = "libpipewire-module-access"; args = { }; }
        { name = "libpipewire-module-adapter"; }
        { name = "libpipewire-module-link-factory"; }
        { name = "libpipewire-module-session-manager"; }
        {
          args = {
            "capture.props" = {
              "audio.position" = [
                "FL"
                "FR"
              ];
              "media.class" = "Audio/Sink";
            };
            "node.description" = "Call (Sink)";
            "node.name" = "pw_vsink_call";
            "playback.props" = {
              "audio.position" = [
                "FL"
                "FR"
              ];
              "node.passive" = true;
              # "node.target" = "alsa_output.pci-0000_09_00.1.hdmi-stereo";
            };
          };
          name = "libpipewire-module-loopback";
        }
      ];

      "context.objects" = [
        {
          # A default dummy driver. This handles nodes marked with the "node.always-driver"
          # properyty when no other driver is currently active. JACK clients need this.
          factory = "spa-node-factory";
          args = {
            "factory.name"     = "support.node.driver";
            "node.name"        = "Dummy-Driver";
            "priority.driver"  = 8000;
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name"     = "support.null-audio-sink";
            "node.name"        = "Microphone-Proxy";
            "node.description" = "Microphone";
            "media.class"      = "Audio/Source/Virtual";
            "audio.position"   = "FL,FR";
          };
        }
        /* {
          factory = "adapter";
          args = {
            "factory.name"     = "support.null-audio-sink";
            "node.name"        = "Main-Output-Proxy";
            "node.description" = "Main Output";
            "media.class"      = "Audio/Sink";
            "audio.position"   = "FL,FR";
          };
        } */
      ];
    };
  };
}

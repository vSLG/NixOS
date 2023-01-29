# Jun's personal NixOS & home-manager configurations

Here you can find NixOS configurations for all my devices.  
Keep in mind it's still very premature and not modular. For example, [`devices/laptop.nix`](devices/laptop.nix) assumes you use home-manager X session by default.

## Configuration
By now, only user name is configurable. Change your user name in [`flake.nix`](flake.nix) in `outputs` section.

## Devices
- [`devices/inspiron.nix`](devices/inspiron.nix): my personal laptop, miscelaneous use
- [`devices/samsung.nix`](devices/samsung.nix): my work laptop, development focused
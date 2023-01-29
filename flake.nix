{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = github:nix-community/home-manager;
  };

  outputs = { self, nixpkgs, ... }@attrs:
    let 
      cfg = {
        user = "j";
      };
    in {
      nixosConfigurations = {
        samsung = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit attrs cfg; };
          modules = [ ./devices/samsung.nix ];
        };

        inspiron = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit attrs cfg; };
          modules = [ ./devices/inspiron.nix ];
        };
      };
    };
}

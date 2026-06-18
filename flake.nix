{
  description = "macOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    mkSystem = { user, host }: nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit user host; };
      modules = [
        ./darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.users.${user} = import ./home/home.nix;
        }
      ];
    };
  in
  {
    darwinConfigurations = {
      "Leons-MacBook-Pro-2" = mkSystem {
        user = "leonq";
        host = "Leons-MacBook-Pro-2";
      };
      # Add a new machine: mkSystem { user = "leon"; host = "your-hostname"; }
    };
  };
}

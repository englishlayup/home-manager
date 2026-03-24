{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      mkHome =
        {
          system ? "x86_64-linux",
          username,
          hostFile,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
            hostFile
          ];
        };
    in
    {
      homeConfigurations = {
        "englishlayup@framework-13" = mkHome {
          username = "englishlayup";
          hostFile = ./hosts/framework-13.nix;
        };

        "englishlayup@home-server" = mkHome {
          username = "englishlayup";
          hostFile = ./hosts/home-server.nix;
        };

        "englishlayup@DESKTOP-EV2FO3F" = mkHome {
          username = "englishlayup";
          hostFile = ./hosts/wsl.nix;
        };

        "ductran" = mkHome {
          username = "ductran";
          hostFile = ./hosts/wsl.nix;
        };
      };
    };
}

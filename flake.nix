{
  description = "Home Manager configuration of englishlayup";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    {
      homeConfigurations = {
        "englishlayup@framework-13" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              wayland.windowManager.hyprland = {
                enable = true;
                package = null;
                portalPackage = null;
              };
            }
            {
              home.username = "englishlayup";
              home.homeDirectory = "/home/englishlayup";
            }
            ./home.nix
          ];
        };
        "ductran" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              home.username = "ductran";
              home.homeDirectory = "/home/ductran";
            }
            ./home.nix
          ];
        };
      };
    };
}

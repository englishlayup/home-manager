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
      hyprland,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."englishlayup" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            wayland.windowManager.hyprland = {
              enable = true;
              # set the flake package
              package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
              portalPackage =
                hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
            };
          }
          ./home.nix
        ];

      };
    };
}

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
    let
      # Helper to create a home configuration
      mkHome =
        {
          system ? "x86_64-linux",
          username,
          homeDirectory ? "/home/${username}",
          # Package categories: "cli", "dev", "desktop", "personal", "productivity", or "all"
          packageCategories ? [ "all" ],
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit packageCategories; };
          modules = [
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
            ./home.nix
          ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        # Personal laptop - full setup with desktop and personal apps
        "englishlayup@framework-13" = mkHome {
          username = "englishlayup";
          packageCategories = [
            "cli"
            "dev"
            "desktop"
            "personal"
            "productivity"
          ];
          extraModules = [
            {
              wayland.windowManager.hyprland = {
                enable = true;
                package = null;
                portalPackage = null;
              };
            }
          ];
        };

        # WSL/secondary machine - no desktop
        "ductran" = mkHome {
          username = "ductran";
          packageCategories = [
            "cli"
            "dev"
          ];
        };

        # Example: Work laptop - desktop but no personal apps
        # "user@work-laptop" = mkHome {
        #   username = "user";
        #   packageCategories = [ "cli" "dev" "desktop" "productivity" ];
        #   extraModules = [
        #     { wayland.windowManager.hyprland.enable = true; }
        #   ];
        # };

        # Example: Server - minimal CLI only
        # "user@server" = mkHome {
        #   username = "user";
        #   packageCategories = [ "cli" ];
        # };
      };
    };
}

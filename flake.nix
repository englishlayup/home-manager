{
  description = "Home Manager configuration of englishlayup";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/c23168acf558fc24adc8240533c4fbf9591f183e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHomeConfiguration =
        {
          username,
          homeDirectory,
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
            ./home.nix
          ];
        };
    in
    {
      homeConfigurations = {
        "englishlayup" = mkHomeConfiguration {
          username = "englishlayup";
          homeDirectory = "/home/englishlayup";
        };
        "ductran" = mkHomeConfiguration {
          username = "ductran";
          homeDirectory = "/home/ductran";
        };
      };
    };
}

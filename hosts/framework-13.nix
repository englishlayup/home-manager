# Framework 13 laptop - full desktop with personal apps
{ pkgs, ... }:
let
  packages = import ../module/packages.nix { inherit pkgs; };
in
{
  imports = [ ../home.nix ];

  # Desktop + personal + productivity packages
  home.packages = packages.desktop ++ packages.personal;

  # Desktop environment variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "ghostty";
  };

  # Desktop configs
  xdg.configFile = {
    "ghostty" = {
      source = ../ghostty;
      recursive = true;
    };
  };

  # Services
  services.syncthing.enable = true;

  # Vietnamese input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-bamboo ];
  };

  # Desktop programs
  programs.ghostty.enable = true;
}

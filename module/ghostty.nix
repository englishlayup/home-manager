{ lib, config, ... }:
let
  cfg = config.ghostty;
in
{
  options = {
    ghostty.enable = lib.mkEnableOption "Enable Ghostty";
  };
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        # Font configuration
        font-family = "MesloLGS Nerd Font";
        font-size = 12;
        # Mouse
        mouse-hide-while-typing = true;
        # Theme
        theme = "dark:Gruvbox Dark,light:Gruvbox Light";
        background-opacity = 0.9;
        shell-integration = "fish";
      };
    };
  };
}

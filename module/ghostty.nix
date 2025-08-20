{ ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      # Font configuration
      font-family = "MesloLGS Nerd Font";
      font-size = 12;
      # Mouse
      mouse-hide-while-typing = true;
      # Theme
      theme = "dark:GruvboxDark,light:GruvboxLight";
      background-opacity = 0.9;
      shell-integration = "fish";
    };
  };
}

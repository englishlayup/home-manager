# Framework 13 laptop - full desktop with personal apps
{ pkgs, ... }:
let
  packages = import ../module/packages.nix { inherit pkgs; };
in
{
  imports = [ ../home.nix ];

  # Desktop + personal + productivity packages
  home.packages = packages.desktop ++ packages.personal ++ packages.productivity;

  # Desktop environment variables
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    NIXOS_OZONE_WL = "1";
    TERMINAL = "ghostty";
  };

  # Desktop configs
  xdg.configFile = {
    "hypr" = {
      source = ../hypr;
      recursive = true;
    };
    "waybar" = {
      source = ../waybar;
      recursive = true;
    };
    "dunst" = {
      source = ../dunst;
      recursive = true;
    };
    "wofi" = {
      source = ../wofi;
      recursive = true;
    };
    "ghostty" = {
      source = ../ghostty;
      recursive = true;
    };
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Gruvbox-Dark
      gtk-icon-theme-name=Gruvbox-Plus-Dark
    '';
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "x-scheme-handler/terminal" = [ "ghostty.desktop" ];
    };
  };

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 16;
    };
    font = {
      name = "Inter";
      size = 11;
    };
    gtk2.extraConfig = "gtk-application-prefer-dark-theme=1";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-button-images = 1;
      gtk-menu-images = 1;
    };
  };

  # Qt theming
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "adwaita-dark";
  };

  # Services
  services.syncthing.enable = true;
  services.dunst.enable = true;

  # Desktop programs
  programs.waybar.enable = true;
  programs.hyprlock.enable = true;
  programs.wofi.enable = true;
  programs.ghostty.enable = true;

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
  };
}

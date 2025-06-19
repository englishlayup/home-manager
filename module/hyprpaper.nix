{ ... }:
{
  # Hyprpaper configuration (wallpaper)
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Sync/Wallpapers_clean/"
      ];
      wallpaper = [
        ",~/Sync/Wallpapers_clean/"
      ];
    };
  };
}

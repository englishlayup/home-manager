{ ... }:
{
  # Hyprpaper configuration (wallpaper)
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Sync/Wallpapers_clean/1.jpg"
      ];
      wallpaper = [
        ",~/Sync/Wallpapers_clean/1.jpg"
      ];
    };
  };
}

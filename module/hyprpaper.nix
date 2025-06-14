{ ... }:
{
  # Hyprpaper configuration (wallpaper)
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/.config/wallpaper.jpg" # Add your wallpaper here
      ];

      wallpaper = [
        ",~/.config/wallpaper.jpg"
      ];
    };
  };
}

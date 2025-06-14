{ ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#a9b665";
        font = "JetBrains Mono 10";
      };

      urgency_normal = {
        background = "#282828";
        foreground = "#fbf1c7";
        timeout = 10;
      };
    };
  };
}

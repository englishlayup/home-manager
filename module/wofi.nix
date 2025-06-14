{ ... }:
{
  # Wofi configuration (application launcher)
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };

    style = ''
      window {
        margin: 0px;
        border: 2px solid #a9b665;
        background-color: rgba(40, 40, 40, 0.9);
        border-radius: 8px;
      }

      #input {
        padding: 4px;
        margin: 4px;
        padding-left: 20px;
        border: none;
        color: #fbf1c7;
        font-weight: bold;
        background-color: rgba(60, 56, 54, 0.5);
        border-radius: 8px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #fbf1c7;
      }

      #entry:selected {
        background-color: rgba(169, 182, 101, 0.3);
        border-radius: 8px;
      }
    '';
  };
}

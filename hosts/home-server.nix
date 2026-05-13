# Home server - CLI only, no desktop
{ ... }:
{
  imports = [ ../home.nix ];

  systemd.user.services.opencode-web = {
    Unit = {
      Description = "OpenCode Web Server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "%h/.opencode/bin/opencode web --port 4096 --hostname 0.0.0.0";
      EnvironmentFile = "%h/.config/opencode-web/env";
      Restart = "on-failure";
      RestartSec = "5";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

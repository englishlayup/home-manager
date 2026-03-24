# Home server - CLI only, no desktop
{ ... }:
{
  imports = [ ../home.nix ];

  # Base config is enough - just cli + dev tools
}

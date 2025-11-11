{ lib, ... }:
{
  imports = [
    ./ghostty.nix
  ];

  ghostty.enable = lib.mkDefault true;
}

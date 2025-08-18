{ lib, config, pkgs, ... }:

{
  users.users."alvy" = {
    isNormalUser = true;
    description = "Alvy";
    extraGroups = [ "networkmanager" "wheel" "libvertd" ];
    packages = with pkgs; [
      ghostty
      waybar
      nerd-fonts.jetbrains-mono

      steam
      prismlauncher

      touchosc

      reaper
      sonobus
      blender
    ];
    shell = pkgs.fish;
  };
}
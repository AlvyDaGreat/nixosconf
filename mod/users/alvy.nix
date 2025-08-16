{ lib, config, pkgs, ... }:

{
  users.users."alvy" = {
    isNormalUser = true;
    description = "Alvy";
    extraGroups = [ "networkmanager" "wheel" "libvertd" ];
    packages = with pkgs; [
      kdePackages.kate

      ghostty

      btop
      gping

      steam
      prismlauncher

      touchosc
      open-stage-control
      
      reaper

      obs-studio
      obs-studio-plugins.distroav
    ];
    shell = pkgs.fish;
  };
}
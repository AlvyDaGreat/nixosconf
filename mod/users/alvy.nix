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

      reaper
      blender

      obs-studio
      obs-studio-plugins.distroav
      obs-studio-plugins.obs-source-record
      obs-studio-plugins.obs-move-transition
    ];
    shell = pkgs.fish;
  };
}
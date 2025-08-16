{ lib, config, pkgs, ... }:

{
  users.users."alvy" = {
    isNormalUser = true;
    description = "Alvy";
    extraGroups = [ "networkmanager" "wheel" "libvertd" ];
    packages = with pkgs; [
      kdePackages.kate
      btop
      gping
      ghostty
      steam
      prismlauncher

      touchosc
      reaper
    ];
    shell = pkgs.fish;
  };
}
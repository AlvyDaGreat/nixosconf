{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ./mod/users/alvy.nix
    ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "alvy" = import ./mod/users/alvy-home.nix;
    };
  };

  # cache for hyprland and stuff
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "bananapeelnix"; # hostname.

  # Networking
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # bt
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
          Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Graphical
  services.xserver.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    withUWSM = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable automatic login for the user.
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin.enable = false;
  services.displayManager.autoLogin.user = "alvy";
  services.displayManager.defaultSession = "hyprland-uwsm";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;
  programs.steam.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["alvy"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
      inetutils 
      wget
      fastfetch
      tmux
      git
      distrobox
      fzf
      btop
      gping
      waybar
      wofi
      nwg-drawer
      killall
  ];

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      distroav
      obs-source-record
      obs-move-transition
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

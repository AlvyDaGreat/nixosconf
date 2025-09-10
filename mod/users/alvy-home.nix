{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  nixpkgs.config.allowUnfree = true;


  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alvy";
  home.homeDirectory = "/home/alvy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    exec-once = [
      "hyprpaper"
      "waybar"
      "copyq --start-server"
      "mako"
      "wayvnc 0.0.0.0 --config ~/TVDATASYNC/wayvnc_config"
      "distrobox enter archlinux -- companion"
    ];
    bind =
      [
        "$mod CTRL, return, exec, ghostty tmux"
        "$mod, return, exec, ghostty"
        "$mod, Q, exec, kitty"
        "$mod, C, killactive,"
        "$mod, W, killactive,"
        "$mod, E, exec, thunar"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen"
        "$mod, R, exec, wofi --show drun"
        "ALT, Space, exec, wofi --show drun"
        "$mod SHIFT, R, exec, nwg-drawer -nofs"
        "$mod, P, pseudo, # dwindle"
        "$mod, J, togglesplit, # dwindle"
        ", print, exec, grim -g \"$(slurp)\""
        "$mod SHIFT, C, exec, hyprpicker --autocopy"
        "SHIFT CTRL, escape, exec, gnome-system-monitor"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, mouse_down, split:workspace, e+1"
        "$mod, mouse_up, split:workspace, e-1"

        ",XF86MonBrightnessDown, exec, brightnessctl set 2%-"
        ",XF86MonBrightnessUp, exec, brightnessctl set 2%+"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, split:workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, split:movetoworkspacesilent, ${toString ws}"
            ]
          )
          9)
      );

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    general = {
      gaps_in = 1;
      gaps_out = 2;
      border_size = 1;
      "col.active_border" = "rgba(4caf50ff)";
      "col.inactive_border" = "rgba(595959aa)";
      layout = "dwindle";
    };

    decoration = {
      blur = {
        enabled = true;
        size = 4;
        passes = 2;
        new_optimizations = true;
      };
      rounding = 4;
    };

    animations = {
      enabled = true;

      bezier = [
        "sigma, 0.05, 0.9, 0.1, 1"
      ];

      animation = [
        "windows, 1, 4, sigma"
        "windowsOut, 1, 4, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 10, default"
        "fade, 1, 3, default"
        "workspaces, 1, 5, default"
        "layers, 1, 3, sigma"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "slave";
    };

    misc = {
      force_default_wallpaper = 1;
    };
  };

  wayland.windowManager.hyprland.plugins = [
    inputs.hyprsplit.packages."${pkgs.system}".hyprsplit
  ];

  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    font-size = 12;
    theme = "Brogrammer";
    background-opacity = 0.8;
  };

  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybarstyle.css;
    settings = [{
      layer = "top";
      position = "bottom";
      modules-left = [ "hyprland/workspaces" ];
      modules-middle = [ "hyprland/window" ];
      modules-right = [ "tray" "cpu" "battery" "clock" ];

      battery = {
        format = "{icon} {capacity}%";
        format-icons = ["" "" "" "" ""];
      };
      cpu = {
        format = " cpu:{usage}%";
        interval = 5;
      };
      clock = {
        format-alt = "{:%a, %d. %b  %H:%M}";
      };
      "wlr/workspaces" = {
        on-click = "activate";
        sort-by-number = true;
      };
    }];
  };

  services.hyprpaper.enable = true;
  services.hyprpaper.settings = 
  let
    thewallpaper = builtins.fetchurl {
      url = "https://chibi.alvy.moe/kCNFKw25GQFC.jpg";
      sha256 = "9e75765abed0a8ffc65caf894ebc73ecdc3bf1821dae55bfdea4499e5e5636dd";
    };
  in
  {
    preload = [
      thewallpaper
    ];

    wallpaper = [
      ",${thewallpaper}"
    ];
  };

  gtk = {
    enable = true;
    theme = {
      name = "Fluent-green-Dark-compact";
      package = pkgs.fluent-gtk-theme.override {
        sizeVariants = [ "compact" ];
        themeVariants = [ "green" ];

      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "green"; };
    };
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
  };

  home.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
  };

  programs.spicetify = 
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in
  {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      beautifulLyrics
    ];
    theme = spicePkgs.themes.default;
  };

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alvy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
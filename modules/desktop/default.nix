{pkgs, config,...}:
let
  a = "asd";
in
 {
  programs.rofi = {
    enable = true;
    font = "FuraCode Nerd Font";
    plugins = [
      pkgs.rofi-emoji
      pkgs.rofi-calc
      pkgs.rofi-power-menu
    ];

    extraConfig = {
      modi = "drun,filebrowser,window,calc,emoji,combi";
      combi-modi = "drun,filebrowser,window,calc,emoji";
      show-icons = true;
      sort = true;
      matching = "fuzzy";
    };
  };


  programs.feh.enable = true;

  gtk = {
      enable = true;
      theme = {
        name = "Catppuccin";
        package = pkgs.catppuccin-gtk;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "Iosevka Nerd Font";
        size = 13;
      };
      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };
      gtk2.extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
  };

  xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad-contrib
      ];
      config = ./xmonad.hs;
    };

  home.packages = [ pkgs.eww ];

  xdg.configFile = {
    "eww".source = config.lib.file.mkOutOfStoreSymlink ./eww;
  };

  services.picom = {
        enable = true;
        activeOpacity = "0.90";
        blur = true;
        blurExclude = [
          "class_g = 'slop'"
        ];
        extraOptions = ''
          corner-radius = 10;
          blur-method = "dual_kawase";
          blur-strength = "10";
          xinerama-shadow-crop = true;
        '';
        experimentalBackends = true;

        shadowExclude = [
          "bounding_shaped && !rounded_corners"
        ];

        fade = true;
        fadeDelta = 5;
        vSync = true;
        opacityRule = [
          "100:class_g   *?= 'Chromium-browser'"
          "100:class_g   *?= 'Firefox'"
          "100:class_g   *?= 'gitkraken'"
          "100:class_g   *?= 'emacs'"
          "100:class_g   ~=  'jetbrains'"
          "100:class_g   *?= 'slack'"
        ];
        package = pkgs.picom.overrideAttrs(o: {
          src = pkgs.fetchFromGitHub {
            repo = "picom";
            owner = "ibhagwan";
            rev = "44b4970f70d6b23759a61a2b94d9bfb4351b41b1";
            sha256 = "0iff4bwpc00xbjad0m000midslgx12aihs33mdvfckr75r114ylh";
          };
        });
  };
}

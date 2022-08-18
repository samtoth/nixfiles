{ config, pkgs, ... }:
let
   haskell-env = with pkgs.haskell.packages.ghc902; [
    hlint
    ghcid
    hoogle
    dhall
    ormolu
    cabal-install
  ];
  
  haskell-ghc = pkgs.haskell.packages.ghc902.ghcWithPackages
    (p: [
      p.mtl
      p.lens
      p.hspec
      p.xmonad
      p.xmonad-contrib
    ]);
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "samt";
  home.homeDirectory = "/home/samt";

  home.packages = with pkgs; [
    haskell-ghc
    agda
  ] ++ haskell-env;

  programs.kitty = {
    enable = true;
    settings = {
      font_size = "16.0";
      font_family      = "FiraCode Nerd Font";
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";
      background = "#001e26";
      foreground = "#708183";
      selection_foreground ="#93a1a1";
      selection_background = "#002b36";
      cursor = "#708183";

      color0  = "#002731";
      color1  = "#d01b24";
      color2  = "#728905";
      color3  = "#a57705";
      color4  = "#2075c7";
      color5  = "#c61b6e";
      color6  = "#259185";
      color7  = "#e9e2cb";
      color8  = "#001e26";
      color9  = "#bd3612";
      color10 = "#465a61";
      color11 = "#52676f";
      color12 = "#708183";
      color13 = "#5856b9";
      color14 = "#81908f";
      color15 = "#fcf4dc";

    };
  };


  
  programs.rofi = {
    enable = true;
    font = "FiraCode NF 12";
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
  
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.helm
      epkgs.magit
      epkgs.haskell-mode
      epkgs.catppuccin-theme
    ];
    extraConfig =
      ''
            (load-theme 'catppuccin t)

            (require 'haskell-interactive-mode)
            (require 'haskell-process)
            (add-hook 'haskell-mode-hook 'interactive-haskell-mode) 

            (custom-set-variables
              '(haskell-process-suggest-remove-import-lines t)
              '(haskell-process-auto-import-loaded-modules t)
              '(haskell-process-log t))

            (load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))


    '';
  };  

  programs.zsh = {
    enable = true;
    shellAliases = {
      lsl = "ls -l";
      update = "sudo nixos-rebuild switch";
      hms = "home-manager switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  
  xresources.extraConfig = ''
      *background: #24273A
      *foreground: #CAD3F5
      st.borderpx: 32
      st.font: monospace:pixelsize=19
      ! Gray
      *color0: #494D64
      *color8: #5B6078
      ! Red
      *color1: #ED8796
      *color9: #ED8796
      ! Green
      *color2: #A6DA95
      *color10: #A6DA95
      ! Yellow
      *color3: #EED49F
      *color11:  #EED49F
      ! Blue
      *color4: #8AADF4
      *color12: #8AADF4
      ! Maguve
      *color5: #F5BDE6
      *color13: #F5BDE6
      ! Pink
      *color6: #8BD5CA
      *color14: #8BD5CA
      ! Whites
      *color7: #B8C0E0
      *color15: #A5ADCB
    '';

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
      config = ./xmonad/config.hs;
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
  
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

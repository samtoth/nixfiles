args@{ config, pkgs, ... }:
with builtins; with lib;
let
  modPaths = [  ./modules/utils.nix
  	            ./modules/agda.nix
  	     	      ./modules/haskell.nix
                ./modules/desktop/default.nix
             ];
  mods = modPaths; 
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "samt";
  home.homeDirectory = "/home/samt";

  imports = mods;
 
   programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };
 
  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
    };
  }; 
  
  xdg = {
    enable = true;
    configFile = {
      "doom-config/config.el".text = builtins.readFile ./doom.d/config.el; 
      "doom-config/init.el".text = builtins.readFile ./doom.d/init.el; 
      "doom-config/packages.el".text = builtins.readFile ./doom.d/packages.el; 
      "emacs" = {
        source = builtins.fetchGit "https://github.com/hlissner/doom-emacs";
        onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom install
          else
            ${config.xdg.configHome}/emacs/bin/doom sync -u
          fi
        ''}";
      };
    };
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

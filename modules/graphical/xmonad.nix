{ config, pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isLinux {

    services.xserver.windowManager = {
      xmonad = { enable = config.services.xserver.enable; };
    };

    environment.systemPackages = with pkgs; [
      feh # Wallpaper
      playerctl # Media control
    ];

    home-manager.users.${config.user} = {
      xserver.windowManager.xmonad = {
        enableContribAndExtras = true;
        extraPackages = hp: [
          hp.dbus
          hp.monad-logger
          hp.xmonad-contrib
        ];
        config = ./xmonad.hs;
      };
    };

  };

}

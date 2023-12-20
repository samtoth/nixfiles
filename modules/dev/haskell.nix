{config, pkgs, lib, ...}: {

  options.haskell.enable = lib.mkEnableOption "Haskell programming language.";

  config = lib.mkIf config.haskell.enable {
        nix.settings.trusted-public-keys =
          [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
        nix.settings.substituters = [ "https://cache.iog.io" ];
    };
}

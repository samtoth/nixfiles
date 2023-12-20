{
  description = "Sam's cross-system nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows =
        "nixpkgs"; # Use system packages list where available
    };

    inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = {nixpkgs, ...}@inputs: let
     globals = rec {
        user = "samt";
        fullName = "Sam Toth";
        gitName = fullName;
        gitEmail = "sam@toth.co.uk";
        mail.server = "toth.co.uk";
        dotfilesRepo = "git@github.com:samtoth/nixfiles";
      };
     overlays = [];
  in rec {
    nixosConfigurations = {
      SamsLaptop = import ./hosts/laptop { inherits inputs globals overlays };
    };


    homeConfigurations = {
      SamsLaptop = nixosConfigurations.SamsLaptop.config.home-manager.users.${globals.user}.home;
    };
  };
}

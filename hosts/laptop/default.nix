{inputs, globals, overlays}:

with inputs;

nixpgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    globals
    home-manager.nixosModules.home-manager
    ../../modules/common
    ../../modules/nixos
    nixos-hardware.nixosModules.dell-xps-13-9370
    {
      nixpkgs.overlays = overlays;

      # Hardware
      physical = true;
      networking.hostName = "samt";
    }
  ];
}

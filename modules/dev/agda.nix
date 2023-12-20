{pkgs, config, ...}:

let
  my-agda = pkgs.agda.withPackages (p: [ p.standard-library p.cubical p.agda-categories ]);


in
{
    home.packages = [my-agda];
}
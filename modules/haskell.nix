{config, pkgs, ...}:

let
  haskell-env = with pkgs.haskell.packages.ghc902; [
        hlint
    	ghcid
	hoogle
	dhall
    	ormolu
    	cabal-install
    	implicit-hie
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
    home.packages = with pkgs.haskell.packages.ghc902; [
        hlint
    	ghcid
	hoogle
	dhall
    	ormolu
    	cabal-install
    	implicit-hie
	(ghcWithPackages (p: [
           p.mtl
           p.lens   
           p.hspec
           p.xmonad
           p.xmonad-contrib
         ]))
     ];
}
import XMonad
import XMonad.Util.EZConfig

myStartupHook :: X ()
myStartupHook = do
   --spawn "~/.config/xmonad/scripts/pipes.sh &"
   --spawn "~/.config/xmonad/scripts/volume-pipe.sh &"
   --spawn "~/.config/xmonad/scripts/backlight-pipe.sh &"
   spawn "feh --bg-scale ~/Pictures/nix-black-4k.png"

main :: IO ()
main = xmonad $ def
        { modMask = mod4Mask -- Use Super instead of Alt
        , terminal = "alacritty"
        , startupHook = myStartupHook
        -- more changes
        }  `additionalKeys`
           [
             ((mod4Mask, xK_d), spawn "rofi -show combi")
           ]

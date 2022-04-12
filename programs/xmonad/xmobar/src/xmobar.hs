{-# LANGUAGE LambdaCase          #-}
{-# LANGUAGE PostfixOperators    #-}
{-# LANGUAGE ScopedTypeVariables #-}
------------------------------------------------------------------------------
-- |
-- Copyright: (c) 2018, 2019, 2022 Jose Antonio Ortega Ruiz
-- License: BSD3-style (see LICENSE)
--
-- Maintainer: jao@gnu.org
-- Stability: unstable
-- Portability: portable
-- Created: Sat Nov 24, 2018 21:03
--
--
-- An example of a Haskell-based xmobar. Compile it with
--   ghc --make -- xmobar.hs
-- with the xmobar library installed or simply call:
--   xmobar /path/to/xmobar.hs
-- and xmobar will compile and launch it for you and
------------------------------------------------------------------------------

import           Xmobar

import           System.Environment (getArgs)

------------------------------------------------------------------------------

main :: IO ()
main = getArgs >>= \case
  ["-x", n] -> xmobar . config $ read n
  _         -> xmobar . config $      0

------------------------------------------------------------------------------

config :: Int -> Config
config n = defaultConfig
  -- fonts
  { font = regularFont 9
  , additionalFonts =
    [ boldFont 9
    ]

  -- colors
  , bgColor = colorBg
  , fgColor = colorFg

  -- general
  , position = OnScreen n (TopW L 96)
  , overrideRedirect = False
  , commands = myCommands
  , sepChar = "%"
  , alignSep = "}{"
  , template = "%XMonadLog%"
            <> "} %date% <hspace=60/> %cpu% | %memory% * %swap% | %wlxd03745e1e87bwi%"
            <> "{ Vol: %volume% <fn=1><box> %kbd% </box> <fc=#ee9a00>%time%</fc></fn>"
  }

myCommands :: [Runnable]
myCommands =
  [ Run $
      Cpu
        [ "--template", "Cpu: <total>"
        , "--suffix"  , "True"
        , "--Low"     , "3"
        , "--High"    , "50"
        , "--low"     , colorGreen
        , "--normal"  , colorYellow
        , "--high"    , colorRed
        ]
        10
  , Run $ Memory ["-t","Mem: <usedratio>%"] 10
  , Run $ Swap [] 10
  , Run $ Date "%a %d %b %Y" "date" (10 `seconds`)
  , Run $ Date "%H:%M:%S" "time" (1 `seconds`)
  , Run $ Kbd [("us(dvorak)", "us"), ("ru", "ru")]
  , Run $
      Wireless
        "wlxd03745e1e87b"
        [ "--template", "<ssid> <quality>"
        , "--suffix"  , "True"
        , "--Low"     , "40"
        , "--High"    , "70"
        , "--low"     , colorRed
        , "--normal"  , colorYellow
        , "--high"    , colorGreen
        ]
        (10 `seconds`)
  , Run $ Com "/bin/bash" ["-c", "~/.config/xmobar/scripts/get_volume.sh"] "volume" 1
  , Run XMonadLog
  ]
  where
    seconds, minutes :: Int -> Int
    seconds = (* 10)
    minutes = (60 *) . seconds

------------------------------------------------------------------------------

colorBg, colorFg, colorRed, colorGreen, colorYellow, colorCyan :: String
colorBg     = "#222222"
colorFg     = "#cccccc"
colorRed    = "#ff5555"
colorGreen  = "#50fa7b"
colorYellow = "#f1fa8c"
colorCyan   = "#8be9fd"

cyan, green, yellow :: String -> String
cyan = xmobarColor colorCyan ""
green = xmobarColor colorGreen ""
yellow = xmobarColor colorYellow ""

regularFont, boldFont :: Int -> String
regularFont size = "xft:Fira Code:size=" <> show size <> ":antialias=true"
boldFont size = "xft:Fira Code:bold:size=" <> show size <> ":antialias=true"

------------------------------------------------------------------------------
{- | Use xmobar escape codes to output a string with given foreground and
background colors.

Source: https://hackage.haskell.org/package/xmonad-contrib-0.15/docs/src/XMonad.Hooks.DynamicLog.html#xmobarColor
-}
xmobarColor
  :: String  -- ^ foreground color: a color name, or #rrggbb format
  -> String  -- ^ background color
  -> String  -- ^ output string
  -> String
xmobarColor fg bg = wrap open "</fc>"
 where
  open :: String = concat ["<fc=", fg, if null bg then "" else "," <> bg, ">"]

-- | Wrap a string in delimiters, unless it is empty.
-- Source: https://hackage.haskell.org/package/xmonad-contrib-0.15/docs/src/XMonad.Hooks.DynamicLog.html#wrap
wrap
  :: String  -- ^ left delimiter
  -> String  -- ^ right delimiter
  -> String  -- ^ output string
  -> String
wrap _ _ "" = ""
wrap l r m  = l <> m <> r

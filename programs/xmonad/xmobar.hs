Config { overrideRedirect = False
        , font = "xft:Fira Code:size=12:antialias=true"
        , bgColor  = "#5f5f5f"
        , fgColor  = "#f8f8f2"
        , position = TopW L 96
        , commands = [ Run Cpu
                        [ "-L", "3"
                        , "-H", "50"
                        , "--high"  , "red"
                        , "--normal", "green"
                        ] 10
                     , Run Memory ["--template", "Mem: <usedratio>%"] 10
                     , Run Swap [] 10
                     , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                     , Run XMonadLog
                     , Run Kbd [("us(dvorak)", "us"), ("ru", "ru")]
                     , Run Wireless ""
                        [ "--template", "wlan <qualityvbar>"
                        ] 10
                     ]
        , sepChar  = "%"
        , alignSep = "}{"
        , template = "%XMonadLog% }{ %cpu% | %memory% * %swap% <hspace=60/> %wi% | <box> %kbd% </box> | %date% "
        }

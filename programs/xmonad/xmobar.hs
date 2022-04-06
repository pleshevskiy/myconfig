Config { overrideRedirect = False
        , font = "xft:Fira Code:size=12:antialias=true"
        , bgColor  = "#5f5f5f"
        , fgColor  = "#f8f8f2"
        , position = Top
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
                     ]
        , sepChar  = "%"
        , alignSep = "}{"
        --, template = "%XMonadLog% }{ %alsa:default:Master% | %cpu% | %memory% * %swap% | %EGPF% | %date% "
        , template = "%XMonadLog% }{ %cpu% | %memory% * %swap% | %date% "
        }

--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import           Data.Monoid
import           System.Exit
import           XMonad
import           XMonad.Actions.CycleSelectedLayouts (cycleThroughLayouts)
import           XMonad.Actions.EasyMotion           (selectWindow)
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.StatusBar
import           XMonad.Hooks.StatusBar.PP
import           XMonad.Layout.Grid
import           XMonad.Layout.NoBorders
import           XMonad.Layout.PerWorkspace
import           XMonad.Util.EZConfig
import           XMonad.Util.Run

import qualified Data.Map                            as M
import qualified XMonad.StackSet                     as W

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1:web", "2:front", "3:back", "4:chat"] <> map show [5..9]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#444"
myFocusedBorderColor = "#f00"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf = mkKeymap conf $

  -- launch a terminal
  [ ("M-S-<Return>", spawn $ XMonad.terminal conf)

  -- launch a 'flameshot' to screenshot
  , ("M-S-s", safeSpawn "flameshot" ["gui"])

  -- launch 'dmenu_run' to choose applications
  , ("M-p", spawn "dmenu_run")

  -- close focused window
  , ("M-S-c", kill)

   -- Rotate through the available layout algorithms
  , ("M-<Space>", cycleThroughLayouts ["Full", "Tall"])
  , ("M-<Tab>", cycleThroughLayouts ["Grid", "Tall"])

  --  Reset the layouts on the current workspace to default
  , ("M-S-<Space>", setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size
  , ("M-n", refresh)

  -- Easy moution to focus windows
  , ("M-s", selectWindow def >>= (`whenJust` windows . W.focusWindow))
  -- Move focus to the next window
  , ("M-j", windows W.focusDown)
  -- Move focus to the previous window
  , ("M-k", windows W.focusUp)
  -- Move focus to the master window
  , ("M-m", windows W.focusMaster)

  -- Swap the focused window and the master window
  , ("M-<Return>", windows W.swapMaster)
  -- Swap the focused window with the next window
  , ("M-S-j", windows W.swapDown)
  -- Swap the focused window with the previous window
  , ("M-S-k", windows W.swapUp)

  -- Shrink the master area
  , ("M-h", sendMessage Shrink)
  -- Expand the master area
  , ("M-l", sendMessage Expand)

  -- Push window back into tiling
  , ("M-t", withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area
  , ("M-,", sendMessage $ IncMasterN 1)
  -- Deincrement the number of windows in the master area
  , ("M-.", sendMessage $ IncMasterN (-1))

  -- Toggle the status bar gap
  -- Use this binding with avoidStruts from Hooks.ManageDocks.
  -- See also the statusBar function from Hooks.DynamicLog.
  --
  , ("M-b", sendMessage ToggleStruts)


  -- Lock screen
  , ("M4-l", spawn "bash ~/scripts/lock.sh")

  -- Change volume
  , ("<XF86AudioMute>",         spawn "amixer -qD pulse sset Master toggle")
  , ("<XF86AudioRaiseVolume>",  spawn "amixer -qD pulse sset Master 1%+")
  , ("<XF86AudioLowerVolume>",  spawn "amixer -qD pulse sset Master 1%-")

  -- Keyboard apps
  , ("<XF86Calculator>", spawn "gnome-calculator")

  -- Quit xmonad
  , ("M4-S-q", io exitSuccess)
  -- Restart xmonad
  , ("M-q", spawn "xmonad --recompile; xmonad --restart")

  -- Run xmessage with a summary of the default keybindings (useful for beginners)
  , ("M-S-/", xmessage help)

  ]
  ++

  --
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  --
  [("M-" ++ m ++ show k, windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [1..9]
    , (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts
  $ onWorkspace "web" (myTall (1/2) ||| myFull ||| Grid)
  $ onWorkspace "chat" (myTall (1/2))
  $ myTall (2/3) ||| myFull ||| Grid
  where
    myTall = smartBorders . Tall nmaster delta

    myFull = noBorders Full

    -- The default number of windows in the master pane
    nmaster = 1

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
  [ resource  =? "desktop_window"         --> doIgnore
  , resource  =? "kdesktop"               --> doIgnore
  -- apps
  , className =? "Gimp"                   --> doFloat
  , className =? "Gnome-calculator"       --> doFloat
  , className =? "Gnome-font-viewer"      --> doFloat
  , className =? "Org.gnome.Nautilus"     --> doFloat
  , className =? "firefox-trunk-nightly"  --> doShift "web"
  , resource  =? "telegram-desktop"       --> doShift "chat"
  , className =? "Thunderbird"            --> doShift "chat"
  -- my libs
  , resource  =? "hwt"                    --> doFloat
  ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad . ewmhFullscreen . ewmh . xmobarProp $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def
  -- simple stuff
  { terminal           = myTerminal
  , focusFollowsMouse  = myFocusFollowsMouse
  , clickJustFocuses   = myClickJustFocuses
  , borderWidth        = myBorderWidth
  , modMask            = myModMask
  , workspaces         = myWorkspaces
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  -- key bindings
  , keys               = myKeys
  , mouseBindings      = myMouseBindings
  -- hooks, layouts
  , layoutHook         = myLayout
  , manageHook         = myManageHook
  , handleEventHook    = myEventHook
  , logHook            = myLogHook
  , startupHook        = myStartupHook
  }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines
  [ "The default modifier key is 'alt'. Default keybindings:"
  , ""
  , "-- launching and killing programs"
  , "mod-Shift-Enter  Launch 'alacritty' terminal"
  , "mod-Shift-s      Launch 'flameshot' to screenshot"
  , "mod-p            Launch 'dmenu_run'"
  , "mod-Shift-c      Close/kill the focused window"
  , "mod-Shift-/      Show this help message with the default keybindings"
  , ""
  , "-- move focus up or down the window stack"
  , "mod-j          Move focus to the next window"
  , "mod-k          Move focus to the previous window"
  , "mod-m          Move focus to the master window"
  , ""
  , "-- modifying the window order"
  , "mod-Return   Swap the focused window and the master window"
  , "mod-Shift-j  Swap the focused window with the next window"
  , "mod-Shift-k  Swap the focused window with the previous window"
  , ""
  , "-- workspace layout"
  , "mod-Space        Rotate through the available layout algorithms"
  , "mod-Shift-Space  Reset the layouts on the current workspace to default"
  , "mod-n            Resize/refresh viewed windows to the correct size"
  , "mod-h            Shrink the master area"
  , "mod-l            Expand the master area"
  , "mod-t            Push window back into tiling; unfloat and re-tile it"
  , ""
  , "-- increase or decrease number of windows in the master area"
  , "mod-comma  (mod-,)   Increment the number of windows in the master area"
  , "mod-period (mod-.)   Deincrement the number of windows in the master area"
  , ""
  , "-- System "
  , "mod4-l         Lock screen"
  , "mod4-Shift-q   Quit xmonad"
  , "mod-q          Restart xmonad"
  , ""
  , "-- Workspaces & screens"
  , "mod-[1..9]         Switch to workSpace N"
  , "mod-Shift-[1..9]   Move client to workspace N"
  , "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3"
  , "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3"
  , ""
  , "-- Mouse bindings: default actions bound to mouse events"
  , "mod-button1  Set the window to floating mode and move by dragging"
  , "mod-button2  Raise the window to the top of the stack"
  , "mod-button3  Set the window to floating mode and resize by dragging"
  , ""
  , "-- Volume"
  , "<XF86AudioMute>          Mute/Unmute"
  , "<XF86AudioRaiseVolume>   Increase volume by 1%"
  , "<XF86AudioLowerVolume>   Decrease volume by 1%"
  ]

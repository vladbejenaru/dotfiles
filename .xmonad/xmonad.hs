----------------------------------------------------------------------------------------------------------------------
---IMPORTS
----------------------------------------------------------------------------------------------------------------------
    -- Base
import XMonad
import Data.Maybe (isJust)
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Utilities
import XMonad.Util.Loggers
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)  
import XMonad.Util.NamedScratchpad (NamedScratchpad(NS), namedScratchpadManageHook, namedScratchpadAction, customFloating)
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, defaultPP, wrap, pad, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat) 
import XMonad.Hooks.Place (placeHook, withGaps, smart)
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.FloatNext (floatNextHook, toggleFloatNext, toggleFloatAllNew)
import XMonad.Hooks.SetWMName

    -- Actions
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.CopyWindow (kill1, copyToAll, killAllOtherCopies, runOrCopy)
import XMonad.Actions.WindowGo (runOrRaise, raiseMaybe)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..)) 
import XMonad.Actions.GridSelect (GSConfig(..), goToSelected, bringSelected, colorRangeFromClassName, buildDefaultGSConfig)
import XMonad.Actions.DynamicWorkspaces (addWorkspacePrompt, removeEmptyWorkspace)
import XMonad.Actions.Warp (warpToWindow, banishScreen, Corner(LowerRight))
import XMonad.Actions.MouseResize
import qualified XMonad.Actions.ConstrainedResize as Sqr

    -- Layouts modifiers
import XMonad.Layout.PerWorkspace (onWorkspace) 
import XMonad.Layout.Renamed (renamed, Rename(CutWordsLeft, Replace))
import XMonad.Layout.WorkspaceDir 
import XMonad.Layout.Spacing (spacing) 
import XMonad.Layout.Minimize
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.BoringWindows (boringWindows)
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.Reflect (reflectVert, reflectHoriz, REFLECTX(..), REFLECTY(..))
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), Toggle(..), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.OneBig
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.ZoomRow (zoomRow, zoomIn, zoomOut, zoomReset, ZoomMessage(ZoomFullToggle))
import XMonad.Layout.IM (withIM, Property(Role))

    -- Prompts
import XMonad.Prompt (defaultXPConfig, XPConfig(..), XPPosition(Top), Direction1D(..))

----------------------------------------------------------------------------------------------------------------------
---CONFIG
----------------------------------------------------------------------------------------------------------------------
myModMask       = mod4Mask  -- Sets modkey to super/windows key
myTerminal      = "termite"   -- Sets default terminal
myTextEditor    = "editor"  -- Sets default text editor
myBorderWidth   = 3         -- Sets border width for windows
windowCount 	= gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/derek/.config/xmobar/xmobarrc0"  -- Launches xmobar
    xmproc1 <- spawnPipe "xmobar -x 1 /home/derek/.config/xmobar/xmobarrc0"  -- Launches xmobar
    xmproc2 <- spawnPipe "xmobar -x 2 /home/derek/.config/xmobar/xmobarrc0"  -- Launches xmobar 
    xmonad $ defaultConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> manageHook defaultConfig <+> manageDocks
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x  >> hPutStrLn xmproc2 x
                        , ppCurrent = xmobarColor "#DDCCBB" "" . wrap "[" "]"  -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#DDCCBB" "" . wrap "" ""    -- Visible but not current workspace
                        , ppHidden = xmobarColor "#99865E" ""                  -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#99865E" ""         -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#DDCCBB" "" . shorten 80      -- Title of active window in xmobar
                        , ppSep =  "<fc=#8A9C9E> :: </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#ff0000" "" . wrap "!" "!"   -- Urgent workspace
                        , ppExtras  = [windowCount]							   -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:exs) -> [ws,l]++exs++[t]
                        }
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook 
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth 
        , normalBorderColor  = "#151515"
        , focusedBorderColor = "#76581E"
        } `additionalKeysP`         myKeys 

----------------------------------------------------------------------------------------------------------------------
---AUTOSTART
----------------------------------------------------------------------------------------------------------------------
myStartupHook = do
          spawnOnce "nitrogen --restore &" 
          spawnOnce "compton --config /home/derek/.config/compton/compton.conf &" 
          setWMName "LG3D"
          --spawnOnce "/home/derek/.xmonad/xmonad.start"                                    -- Sets our wallpaper
          --spawnOnce "compton -cCGfF -o 1.00 -O 0.100 -I 0.100 -t 0 -l 0 -r 3 -D2 -m 0.88 --opacity-rule 75:'class_g *=\"XTerm\"' &"  	-- Enables compositing

----------------------------------------------------------------------------------------------------------------------
---KEYBINDINGS
----------------------------------------------------------------------------------------------------------------------
myKeys =
    -- Xmonad
        [ ("M-C-r",             spawn "xmonad --recompile")      -- Recompiles xmonad
        , ("M-S-r",             spawn "xmonad --restart")        -- Restarts xmonad
        , ("M-S-q",             io exitSuccess)                  -- Quits xmonad
    
    -- Windows
        , ("M-r",               refresh)                         -- Refresh
        , ("M-C-1",             kill1)                           -- Kill the currently focused client
        , ("M-C-a",             killAll)                         -- Kill all the windows on the current workspace
        
        , ("M-<Delete>",        withFocused $ windows . W.sink)
        , ("M-S-<Delete>",      sinkAll)                         -- Pushes all floating windows on current workspace back into tiling
        , ("M-m",               windows W.focusMaster)           -- Move focus to the master window
        , ("M-j",               windows W.focusDown)             -- Move focus to the next window
        , ("M-k",               windows W.focusUp)               -- Move focus to the prev window
        , ("M-S-m",             windows W.swapMaster)            -- Swap the focused window and the master window
        , ("M-S-j",             windows W.swapDown)              -- Swap the focused window with the next window
        , ("M-S-k",             windows W.swapUp)                -- Swap the focused window with the prev window
        , ("M-<Backspace>",     promote)                         -- Moves focused window to master window. All others maintain order
        , ("M1-S-<Tab>",        rotSlavesDown)                   -- Rotate all windows except the master and keep the focus in place
        , ("M1-C-<Tab>",        rotAllDown)                      -- Rotate all the windows in the current stack

        , ("M-*",               withFocused minimizeWindow)
        , ("M-S-*",             sendMessage RestoreNextMinimizedWin)
        , ("M-!",               withFocused (sendMessage . maximizeRestore))
        , ("M-$",               toggleFloatNext)
        , ("M-S-$",             toggleFloatAllNew)
        , ("M-S-s",             windows copyToAll) 
        , ("M-C-s",             killAllOtherCopies) 

        , ("M-C-M1-<Up>",       sendMessage Arrange)
        , ("M-C-M1-<Down>",     sendMessage DeArrange)
        , ("M-<Up>",            sendMessage (MoveUp 10))         --  Move focused window to up
        , ("M-<Down>",          sendMessage (MoveDown 10))       --  Move focused window to down
        , ("M-<Right>",         sendMessage (MoveRight 10))      --  Move focused window to right
        , ("M-<Left>",          sendMessage (MoveLeft 10))       --  Move focused window to left
        , ("M-S-<Up>",          sendMessage (IncreaseUp 10))     --  Increase size of focused window up
        , ("M-S-<Down>",        sendMessage (IncreaseDown 10))   --  Increase size of focused window down
        , ("M-S-<Right>",       sendMessage (IncreaseRight 10))  --  Increase size of focused window right
        , ("M-S-<Left>",        sendMessage (IncreaseLeft 10))   --  Increase size of focused window left
        , ("M-C-<Up>",          sendMessage (DecreaseUp 10))     --  Decrease size of focused window up
        , ("M-C-<Down>",        sendMessage (DecreaseDown 10))   --  Decrease size of focused window down
        , ("M-C-<Right>",       sendMessage (DecreaseRight 10))  --  Decrease size of focused window right
        , ("M-C-<Left>",        sendMessage (DecreaseLeft 10))   --  Decrease size of focused window left

    -- Layouts
        , ("M-S-<Space>",       sendMessage ToggleStruts)
        , ("M-d",               asks (XMonad.layoutHook . config) >>= setLayout)
        , ("M-<KP_Enter>",      sendMessage NextLayout)
        , ("M-S-f",             sendMessage (T.Toggle "float"))
        , ("M-S-g",             sendMessage (T.Toggle "gimp"))
        , ("M-S-x",             sendMessage $ Toggle REFLECTX)
        , ("M-S-y",             sendMessage $ Toggle REFLECTY)
        , ("M-S-m",             sendMessage $ Toggle MIRROR)
        , ("M-S-b",             sendMessage $ Toggle NOBORDERS)
        , ("M-S-d",             sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts)
        , ("M-<KP_Multiply>",   sendMessage (IncMasterN 1))      -- Increase the number of clients in the master pane
        , ("M-<KP_Divide>",     sendMessage (IncMasterN (-1)))   -- Decrease the number of clients in the master pane
        , ("M-S-<KP_Multiply>", increaseLimit)                   -- Increase the number of windows that can be shown
        , ("M-S-<KP_Divide>",   decreaseLimit)                   -- Decrease the number of windows that can be shown

        , ("M-h",               sendMessage Shrink)
        , ("M-l",               sendMessage Expand)
        , ("M-S-;",             sendMessage zoomReset)
        , ("M-;",               sendMessage ZoomFullToggle)

    -- Workspaces
        , ("M-<KP_Add>",        moveTo Next nonNSP)                         -- Go to next workspace
        , ("M-<KP_Subtract>",   moveTo Prev nonNSP)                         -- Go to previous workspace
        , ("M-S-<KP_Add>",      shiftTo Next nonNSP >> moveTo Next nonNSP)  -- Shifts focused window to next workspace
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to previous workspace

    -- Main Run Apps
        , ("M-<Return>",        spawn myTerminal)
        , ("M-<Space>",         spawn "dmenu_run -nb '#1f1f2c' -nf '#91A0BD' -sb '#1f1f2c' -sf '#6c5c8b' -p 'SEARCH ::' -fn 'ubuntu mono-7' -i")
        
    -- Command Line Apps
        , ("M-<KP_End>",        spawn (myTerminal ++ " -e 'irssi'"))                             -- Keypad 1
        , ("M-<KP_Down>",       spawn (myTerminal ++ " -e 'canto -u'"))                          -- Keypad 2
        , ("M-<KP_Page_Down>",  spawn (myTerminal ++ " -e 'htop'"))                              -- Keypad 3
        , ("M-<KP_Left>",       spawn (myTerminal ++ " -e 'ncmpcpp'"))                           -- Keypad 4
        , ("M-<KP_Begin>",      spawn (myTerminal ++ " -e 'lynx http://www.omgubuntu.co.uk'"))   -- Keypad 5
        , ("M-<KP_Right>",      spawn (myTerminal ++ " -e 'rtorrent'"))                          -- Keypad 6
        , ("M-<KP_Home>",       spawn (myTerminal ++ " -e 'vim /home/derek/.xmonad/xmonad.hs'")) -- Keypad 7
        , ("M-<KP_Up>",         spawn (myTerminal ++ " -e 'alsamixer'"))                         -- Keypad 8
        , ("M-<KP_Page_Up>",    spawn (myTerminal ++ " -e 'ranger'"))                            -- Keypad 9
        
    -- GUI Apps
        , ("M-w",    safeSpawn "firefox" ["http://localhost/homepage/"])
        , ("M-t",               spawn "thunar")
        , ("M-g",               runOrRaise "geany" (resource =? "geany"))

    -- Multimedia Keys
        , ("<XF86AudioPlay>",   spawn "ncmpcpp toggle")
        , ("<XF86AudioPrev>",   spawn "ncmpcpp prev")
        , ("<XF86AudioNext>",   spawn "ncmpcpp next")
        -- , ("<XF86AudioMute>",   spawn "amixer set Master toggle")  -- Bug prevents it from toggling correctly in 12.04.
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>",    safeSpawn "firefox" ["http://localhost/homepage/"])
        , ("<XF86Search>",      safeSpawn "firefox" ["https://www.google.com/"])
        , ("<XF86Mail>",        runOrRaise "thunderbird" (resource =? "thunderbird"))
        , ("<XF86Calculator>",  runOrRaise "gcalctool" (resource =? "gcalctool"))
        , ("<XF86Eject>",       spawn "toggleeject")
        , ("<Print>",           spawn "scrotd 0")
        ] where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
                
----------------------------------------------------------------------------------------------------------------------
---WORKSPACES
----------------------------------------------------------------------------------------------------------------------
--myWorkspaces = ["main", "web", "text", "chat", "media", "syst"]

xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]
        
myWorkspaces :: [String]   
myWorkspaces = clickable . (map xmobarEscape) $ ["main", "web", "text", "chat", "media", "syst"]
  where                                                                      
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                             (i,ws) <- zip [1..6] l,                                        
                            let n = i ] 

myManageHook = placeHook (withGaps (20,12,12,12) (smart (0.5,0.5))) <+> insertPosition End Newer <+> floatNextHook <+>
        (composeAll . concat $
        [ [ resource  =? r --> doF (W.view "main" . W.shift "main")   | r <- myTermApps    ]
        , [ resource  =? r --> doF (W.view "web" . W.shift "web")   | r <- myWebApps     ]
        , [ resource  =? r --> doF (W.view "media" . W.shift "media") | r <- myMediaApps   ]
        , [ resource  =? r --> doF (W.view "syst" . W.shift "syst")   | r <- mySystApps    ]
        , [ resource  =? r --> doFloat                            | r <- myFloatApps   ]
        , [ className =? c --> ask >>= doF . W.sink               | c <- myUnfloatApps ]
        ]) <+> manageHook defaultConfig
        where
            myTermApps    = ["termite", "xterm", "htop", "irssi"]
            myWebApps     = ["firefox", "thunderbird"]
            myMediaApps   = ["vlc", "ncmpcpp", "weechat", "mplayer", "gimp"]
            mySystApps    = ["ranger", "thunar", "geany", "nitrogen"]

            myFloatApps   = ["file-roller", "nitrogen"]
            myUnfloatApps = ["gimp"]


----------------------------------------------------------------------------------------------------------------------
---LAYOUTS
----------------------------------------------------------------------------------------------------------------------
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts float $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ renamed [CutWordsLeft 4] $ maximize $ minimize $ boringWindows $ spacing 0 $
                onWorkspace "main"  myTermLayout $
                onWorkspace "web"  myWebLayout $
                onWorkspace "text"  myTextLayout $
                onWorkspace "chat"  myChatLayout $
                onWorkspace "media" myMediaLayout $
                onWorkspace "syst"  mySystLayout 
                myDefaultLayout
    where
        myTermLayout    = workspaceDir "~"                 $ grid  ||| threeCol ||| threeRow ||| oneBig ||| float
        myWebLayout     = workspaceDir "~"                 $ noBorders monocle ||| oneBig ||| threeCol ||| threeRow ||| grid
        myTextLayout    = workspaceDir "~"                 $ oneBig ||| threeCol ||| threeRow ||| grid
        myChatLayout    = workspaceDir "~"                 $ grid  ||| threeCol ||| threeRow ||| oneBig ||| float
        myMediaLayout   = workspaceDir "~"                 $ T.toggleLayouts gimp $ monocle ||| oneBig ||| space ||| threeRow
        mySystLayout    = workspaceDir "~"                 $ threeRow ||| threeCol ||| oneBig ||| space ||| monocle ||| grid
        myDefaultLayout = workspaceDir "~"                 $ grid ||| threeCol ||| threeRow ||| oneBig ||| monocle ||| space ||| float

		
        grid            = renamed [Replace "grid"]         $ limitWindows 12 $ spacing 4 $ mkToggle (single MIRROR) $ Grid (16/10)
        threeCol        = renamed [Replace "threeCol"]     $ limitWindows 3  $ ThreeCol 1 (3/100) (1/2) 
        threeRow        = renamed [Replace "threeRow"]     $ limitWindows 3  $ Mirror $ mkToggle (single MIRROR) zoomRow
        oneBig          = renamed [Replace "oneBig"]       $ limitWindows 6  $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (5/9) (8/12)
        monocle         = renamed [Replace "monocle"]      $ limitWindows 20   Full
        space           = renamed [Replace "space"]        $ limitWindows 4  $ spacing 36 $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (2/3) (2/3)
        float           = renamed [Replace "float"]        $ limitWindows 20   simplestFloat
        gimp            = renamed [Replace "gimp"]         $ limitWindows 5  $ withIM 0.11 (Role "gimp-toolbox") $ reflectHoriz $ withIM 0.15 (Role "gimp-dock") Full


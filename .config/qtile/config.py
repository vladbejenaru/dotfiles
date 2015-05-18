# -*- coding: utf-8 -*-
# A customized config.py for Qtile window manager (http://www.qtile.org)     
# Modified by Derek Taylor ( https://github.com/dwt1 )
#
# The following comments are the copyright and licensing information from the default config.
# Copyright (c) 2010 Aldo Cortesi, 2010, 2014 dequis, 2012 Randall Ma, 2012-2014 Tycho Andersen, 
# 2012 Craig Barnes, 2013 horsik, 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
# and associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, 
# sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial 
# portions of the Software.

##### IMPORTS #####

import os
import socket
import subprocess, re
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

##### KEYBINDINGS #####

mod = "mod4"                                                 # Sets mod key to SUPER/WINDOWS
myTerm = "urxvt"                                             # My terminal of choice
myConfig = "/home/derek/.config/qtile/config.py"             # Qtile config file location 

keys = [
    Key(
        [mod], "Return", 
        lazy.spawn(myTerm)                                   # Open terminal
        ),
    Key(
        [mod], "Tab", 
        lazy.next_layout()                                   # Toggle through layouts
        ),
    Key(
        [mod, "shift"], "c", 
        lazy.window.kill()                                   # Kill active window
        ),
    Key(
        [mod, "shift"], "r", 
        lazy.restart()                                       # Restart Qtile
        ),
    Key(
        [mod, "shift"], "q", 
        lazy.shutdown()                                      # Shutdown Qtile
        ),
    # Window controls
    Key(
        [mod], "k", 
        lazy.layout.down()                                   # Switch between windows in current stack pane
        ),
    Key(
        [mod], "j", 
        lazy.layout.up()                                     # Switch between windows in current stack pane
        ),
    Key(
        [mod, "shift"], "k", 
        lazy.layout.shuffle_down()                           # Move windows down in current stack
        ),
    Key(
        [mod, "shift"], "j", 
        lazy.layout.shuffle_up()                             # Move windows up in current stack
        ),
    Key(
        [mod, "shift"], "l", 
        lazy.layout.grow(),                                  # Grow size of current window (XmonadTall)
        lazy.layout.increase_nmaster(),                      # Increase number in master pane (Tile)
        ),
    Key(
        [mod, "shift"], "h", 
        lazy.layout.shrink(),                                # Shrink size of current window (XmonadTall)
        lazy.layout.decrease_nmaster(),                      # Decrease number in master pane (Tile)
        ),
    Key(
        [mod], "n", 
        lazy.layout.normalize()                              # Restore all windows to default size ratios 
        ),
    Key(
        [mod], "m", 
        lazy.layout.maximize()                               # Toggle a window between minimum and maximum sizes
        ),
        
    Key(
        [mod, "shift"], "KP_Enter", 
        lazy.window.toggle_floating()                        # Toggle floating
        ),
    Key(
        [mod, "shift"], "space", 
        lazy.layout.rotate(),                                # Swap panes of split stack (Stack)
        lazy.layout.flip()                                   # Switch which horizontal side main pane occupies (XmonadTall)
        ),
    # Stack controls
    Key(
        [mod], "space", 
        lazy.layout.next()                                   # Switch window focus to other pane(s) of stack
        ),
    Key(
        [mod, "control"], "Return", 
        lazy.layout.toggle_split()                           # Toggle between split and unsplit sides of stack
        ),
    
    # GUI Apps
    Key(
        [mod], "w", 
        lazy.spawn("firefox")
        ),
    Key(
        [mod], "t", 
        lazy.spawn("thunderbird")
        ),
    Key(
        [mod], "f", 
        lazy.spawn("pcmanfm")
        ),
    Key(
        [mod], "g", 
        lazy.spawn("geany")
        ),
    
    # Command Line Apps
    Key(
        [mod], "KP_Insert",                                  # Keypad 0
        lazy.spawncmd()                                      # Run Dialog
        ),
    Key(
        [mod], "KP_End",                                     # Keypad 1
        lazy.spawn(myTerm+" -e irssi")
        ),
    Key(
        [mod], "KP_Down",                                    # Keypad 2
        lazy.spawn(myTerm+" -e canto -u")
        ),
    Key(
        [mod], "KP_Page_Down",                               # Keypad 3
        lazy.spawn(myTerm+" -e htop") 
        ), 
    Key(
        [mod], "KP_Left",                                    # Keypad 4
        lazy.spawn(myTerm+" -e ncmpcpp")
        ),
    Key(
        [mod], "KP_Begin",                                   # Keypad 5
        lazy.spawn(myTerm+" -e lynx http://www.omgubuntu.co.uk")
        ), 
    Key(
        [mod], "KP_Right",                                   # Keypad 6
        lazy.spawn(myTerm+" -e /home/derek/colortest.sh") 
        ),
    Key(
        [mod], "KP_Home",                                    # Keypad 7
        lazy.spawn(myTerm+" -e vim "+myConfig)
        ),
    Key(
        [mod], "KP_Up",                                      # Keypad 8
        lazy.spawn(myTerm+" -e /home/derek/pipes2")
        ),
    Key(
        [mod], "KP_Page_Up",                                 # Keypad 9
        lazy.spawn(myTerm+" -e ranger")
        ),
]

##### COLORS #####

def init_colors():
    return [["#CEFF7C", "#D1FF6A"], # bright, light green for widget icons
            ["#131313", "#000000"], # black gradiant for bar background
            ["#909E51", "#909E51"], # green gradiant for bar background
            ["#906756", "#927E7E"], # light green gradiant for this screen tab
            ["#57403E", "#665453"], # dark green gradiant for other screen tabs
            ["#ffffff", "#d7d7d7"], # dark green gradiant for other screen tabs
            ["#746C48", "#8F7E54"], # dark green gradiant for other screen tabs
            ["#464F2D", "#4F5930"], # green gradiant for bar background
            ["#C45500", "#E7653F"]] # light green gradiant for this screen tab

colors = init_colors()
    
##### GROUPS #####

group_names = [
    ("ONE", {'layout': 'max'}),
    ("TWO", {'layout': 'max'}),
    ("THREE", {'layout': 'monadtall'}),
    ("FOUR", {'layout': 'monadtall'}),
    ("FIVE", {'layout': 'tile'}),
    ("SIX", {'layout': 'floating'}),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))

##### LAYOUTS #####

layout_theme = {
    "border_width": 2,
    "margin": 3,
    "border_focus": "60C307",
    "border_normal": "000000"
    }
layouts = [
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.TreeTab(font = "MintsStrong",
                   fontsize = 8, 
                   sections = ["FIRST", "SECOND"],
                   section_fontsize = 8, 
                   bg_color = "141414", 
                   active_bg = "90C435", 
                   active_fg = "000000", 
                   inactive_bg = "384323", 
                   inactive_fg = "a0a0a0", 
                   padding_y = 5,
                   section_top = 10,
                   **layout_theme
                   ),
    layout.Tile(shift_windows=True, **layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Stack(stacks=2, **layout_theme),
    layout.Zoomy(**layout_theme),
    layout.Floating(**layout_theme),
]

widget_defaults = dict(
    font='MintsStrong',
    fontsize=8,
    padding=1,
)
    
##### SCREENS #####

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())  # Modifies Run Cmd Dialog

screens = [
    # Screen 1 on my triple monitor setup
    Screen(
        top=bar.Bar(
            [
               widget.GroupBox(margin_y = 0, 
                               margin_x = 0, 
                               padding_y = 6, 
                               padding_x = 3, 
                               borderwidth = 1, 
                               active = colors[6], 
                               inactive = colors[6],
                               rounded = False,
                               highlight_method = "block",
                               this_current_screen_border = colors[7],
                               this_screen_border = colors [4],
                               other_screen_border = colors[1],
                               foreground = colors[2], 
                               background = colors[1]
                               ), 
               widget.Sep(linewidth = 0,
                          padding = 12,
                          foreground = colors[2], 
                          background = colors[1]
                          ),
               widget.WindowName(foreground = colors[3], 
                                 background = colors[1],
                                 padding_y = 6, 
                                 padding_x = 3, 
                                 ),
               widget.TextBox(text=" ☵", 
		                      foreground=colors[3], 
                              background=colors[1],
		                      fontsize=14
		                      ),
               widget.CurrentLayout(foreground = colors[6], 
                                    background = colors[1],
                                    padding = 6,
                                    ),
               widget.TextBox(text=" ↯", 
                              foreground=colors[3], 
                              background=colors[1],
                              fontsize=14
                              ),
               widget.Net(interface = "eth0", 
                          foreground = colors[6], 
                          background = colors[1]
                          ),
               widget.TextBox(text=" ⌚", 
                              foreground=colors[3],
                              background=colors[1], 
                              padding = 3,
                              fontsize=18
                              ),
               widget.Clock(foreground = colors[6], 
                            background = colors[1],
                            format="%A, %B %d - %H:%M"
                            ),
               widget.Sep(linewidth = 0,
                          padding = 6,
                          foreground = colors[8], 
                          background = colors[1]
                          ),
            ],
            24,
        ),
    ),
    # Screen 2 on my triple monitor setup
    Screen(
        top=bar.Bar(
            [
               widget.GroupBox(margin_y = 0, 
                               margin_x = 0, 
                               padding_y = 6, 
                               padding_x = 3, 
                               borderwidth = 1, 
                               active = colors[6], 
                               inactive = colors[6],
                               rounded = False,
                               highlight_method = "block",
                               this_current_screen_border = colors[7],
                               this_screen_border = colors [4],
                               other_screen_border = colors[1],
                               foreground = colors[2], 
                               background = colors[1]
                               ), 
               widget.Prompt(prompt=prompt, 
                             font="MintsStrong",
                             padding=10, 
                             foreground = colors[8], 
                             background=colors[1]
                             ),
               widget.Sep(linewidth = 0,
                          padding = 12,
                          foreground = colors[2], 
                          background = colors[1]
                          ),
               widget.WindowName(foreground = colors[3], 
                                 background = colors[1],
                                 padding_y = 6, 
                                 padding_x = 3, 
                                 ),
               widget.Systray(
                              background=colors[1]
                              ),
               widget.TextBox(text=" ☵", 
		                      foreground=colors[3], 
                              background=colors[1],
		                      fontsize=14
		                      ),
               widget.CurrentLayout(foreground = colors[6], 
                                    background = colors[1],
                                    padding = 6,
                                    ),
               widget.TextBox(text=" ↯", 
                              foreground=colors[3], 
                              background=colors[1],
                              fontsize=14
                              ),
               widget.Net(interface = "eth0", 
                          foreground = colors[6], 
                          background = colors[1]
                          ),
               widget.TextBox(text=" ⌚", 
                              foreground=colors[3],
                              background=colors[1], 
                              padding = 3,
                              fontsize=18
                              ),
               widget.Clock(foreground = colors[6], 
                            background = colors[1],
                            format="%A, %B %d - %H:%M"
                            ),
               widget.Sep(linewidth = 0,
                          padding = 6,
                          foreground = colors[6], 
                          background = colors[1]
                          ),
            ],
            24,
        ),
    ),
    # Screen 3 on my triple monitor setup
    Screen(
        top=bar.Bar(
            [
               widget.GroupBox(margin_y = 0, 
                               margin_x = 0, 
                               padding_y = 6, 
                               padding_x = 3, 
                               borderwidth = 1, 
                               active = colors[6], 
                               inactive = colors[6],
                               rounded = False,
                               highlight_method = "block",
                               this_current_screen_border = colors[7],
                               this_screen_border = colors [4],
                               other_screen_border = colors[1],
                               foreground = colors[2], 
                               background = colors[1]
                               ), 
               widget.Sep(linewidth = 0,
                          padding = 12,
                          foreground = colors[2], 
                          background = colors[1]
                          ),
               widget.WindowName(foreground = colors[3], 
                                 background = colors[1],
                                 padding_y = 6, 
                                 padding_x = 3, 
                                 ),
               widget.TextBox(text=" ☵", 
		                      foreground=colors[3], 
                              background=colors[1],
		                      fontsize=14
		                      ),
               widget.CurrentLayout(foreground = colors[6], 
                                    background = colors[1],
                                    padding = 6,
                                    ),
               widget.TextBox(text=" ↯", 
                              foreground=colors[3], 
                              background=colors[1],
                              fontsize=14
                              ),
               widget.Net(interface = "eth0", 
                          foreground = colors[6], 
                          background = colors[1]
                          ),
               widget.TextBox(text=" ⌚", 
                              foreground=colors[3],
                              background=colors[1], 
                              padding = 3,
                              fontsize=18
                              ),
               widget.Clock(foreground = colors[6], 
                            background = colors[1],
                            format="%A, %B %d - %H:%M"
                            ),
               widget.Sep(linewidth = 0,
                          padding = 6,
                          foreground = colors[6], 
                          background = colors[1]
                          ),
            ],
            24,
        ),
    ),
]

##### MOUSE FUNCTIONS FOR FLOATING #####

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(border_focus = "131313")
auto_fullscreen = True
wmname = "LG3D"   # Needed for Java apps to work correctly

##### STARTUP APPLICATIONS #####

def is_running(process):
    s = subprocess.Popen(["ps", "axw"], stdout=subprocess.PIPE)
    for x in s.stdout:
        if re.search(process, x):
            return True
    return False

def execute_once(process):
    if not is_running(process):
        return subprocess.Popen(process.split())

@hook.subscribe.startup
def startup():
    execute_once("compton --config /home/derek/.config/compton/compton.conf")
    execute_once("xscreensaver -nosplash")
    execute_once("nitrogen --restore")

# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# from Xlib import display as xdisplay


# def get_num_monitors():
#     num_monitors = 0
#     try:
#         display = xdisplay.Display()
#         screen = display.screen(0)
#         resources = screen.root.xrandr_get_screen_resources()
#
#         for output in resources.outputs:
#             monitor = display.xrandr_get_output_info(output, resources.config_timestamp)
#             preferred = False
#             if hasattr(monitor, "preferred"):
#                 prefereed = monitor.preferred
#             elif hasattr(monitor, "num_preferred"):
#                 preferred = monitor.num_preferred
#             if preferred:
#                 num_monitors += 1
#     except Exception as e:
#         return 1
#     else:
#         return num_monitors

def window_to_previous_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen == True:
            qtile.cmd_to_screen(i - 1)

def window_to_next_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen == True:
            qtile.cmd_to_screen(i + 1)


@hook.subscribe.startup_once
def autostart():
    config_dir = os.path.expanduser("~/.config")
    subprocess.Popen([f"{config_dir}/qtile/autostart.sh"])

# @hook.subscribe.startup
# def restart():
#     config_dir = os.path.expanduser("~/.config")
#     subprocess.Popen([f"{config_dir}/polybar/launch.sh"])

mod = "mod4"
terminal = "alacritty"

keys = [
    # App Shortcuts
    Key([mod], "w", lazy.spawn("librewolf"), desc="Open Browser"),

    # Screenshot
    Key([], "Print",                lazy.spawn("maim -s -u | xclip -selection clipboard -t image/png", shell=True), desc="Copy interactive screenshot to clipboard"),
    Key(["Shift"], "Print",         lazy.spawn("maim -s -u $HOME/media/screenshots/$(date +%Y-%m-%d_%a_%H:%M:%S).png", shell=True), desc="Save interactive screenshot"),
    Key([mod], "Print",             lazy.spawn("maim -u | xclip -selection clipboard -t image/png", shell=True), desc="Copy monitor screenshot to clipboard"),
    Key([mod, "Shift"], "Print",    lazy.spawn("maim -u $HOME/media/screenshots/$(date +%Y-%m-%d_%a_%H:%M:%S).png", shell=True), desc="Save monitor screenshot"),

    # Volume
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Toggle Speaker Mute"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"), desc="Increase Speaker Volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"), desc="Decrease Speaker Volume"),
    Key(["shift"], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), desc="Toggle Mic Mute"),
    Key(["shift"], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+"), desc="Increase Mic Volume"),
    Key(["shift"], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-"), desc="Decrease Mic Volume"),
    #Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +1%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 1%-")),
    #Language
    Key([mod], "F1", lazy.spawn("xkbcomp ~/colemak.xkb $DISPLAY", shell=True), desc="Set keyboard layout to Colemak"),
    Key([mod], "F2", lazy.spawn("setxkbmap us"), desc="Set keyboard layout to Qwerty"),

    # Toggle Window State
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating state"),
    Key([mod], "m", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen state"),
    Key([mod, "Shift"], "m", lazy.hide_show_bar("top"), desc="Hide top bar"),

    # Switch between screens
    Key([mod], "comma", lazy.prev_screen(), desc="Switch to previous monitor"),
    Key([mod], "period", lazy.next_screen(), desc="Switch to next monitor"),
    Key([mod, "shift"], "comma", lazy.function(window_to_next_screen, switch_screen=True)),
    Key([mod, "shift"], "period", lazy.function(window_to_previous_screen, switch_screen=True)),
    Key([mod, "control"], "comma", lazy.function(window_to_next_screen)),
    Key([mod, "control"], "period", lazy.function(window_to_previous_screen)),

    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "n", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "o", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "e", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "i", lazy.layout.up(), desc="Move focus up"),
    Key(["mod1"], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    Key(["mod1", "Shift"], "Tab", lazy.layout.previous(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "n", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "o", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "e", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "i", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "n", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "o", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "e", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "i", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "d", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod], "Tab",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod, "control"], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "space", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "space", lazy.spawn("dmenu_run -fn mono-11 -nb black"), desc="Spawn dmenu"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key([mod, "control"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(
        border_normal="#101010",
        border_normal_stack="#303030",
        border_focus="#a0a0a0",
        border_focus_stack="#d0d0d0",
        border_width=2,
        border_on_single=True,
        grow_amount=4,
        insert_position=1,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="FiraMono",
    # font="JetBrainsMono",
    fontsize=15,
    padding=8
)
extension_defaults = widget_defaults.copy()

accent_color = "#61afef"

screens = []

# for j in range(get_num_monitors()):
for j in range(2):
    screens.append(
        Screen(
            wallpaper="~/.config/qtile/wallpaper.jpg",
            wallpaper_mode="fill",

            top=bar.Bar(
                [
                    widget.Spacer(length=7),
                    widget.GroupBox(
                        highlight_color=["61afef", "282828"],
                        borderwidth=2,
                        margin_y=2,
                        padding=2
                    ),
                    widget.Sep(foreground="707070", size_percent=50),
                    widget.WindowName(width=640, max_chars=64),

                    widget.Spacer(),
                    widget.Clock(format="%Y-%m-%d %a %H:%M:%S"),
                    # widget.Mpd2(),
                    widget.Spacer(),

                    widget.CPU(
                        fmt=f"<span foreground='{accent_color}'>CPU:</span> {{}}%",
                        format="{load_percent}",
                        update_interval=1
                    ),
                    widget.Sep(foreground="707070", size_percent=50),
                    widget.Memory(
                        fmt=f"<span foreground='{accent_color}'>RAM:</span> {{}} MiB",
                        format="{MemUsed:.0f}",
                        update_interval=1
                    ),
                    widget.Sep(foreground="707070", size_percent=50),
                    widget.PulseVolume(
                        fmt=f"<span foreground='{accent_color}'>Spk:</span> {{}}",
                        channel="Master",
                        update_interval=0.1
                    ),
                    widget.Sep(foreground="707070", size_percent=50),
                    widget.Battery(
                        fmt=f"<span foreground='{accent_color}'>Bat:</span> {{}}",
                        format="{percent:1.0%}{char}",
                        charge_char="+",
                        discharge_char="-",
                        unknown_char="",
                        notify_below=5
                    ),
                    widget.CurrentLayoutIcon(scale=0.80),
                ],
                26
            )
        )
    )

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = False
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
# wmname = "LG3D"

-- Miscellaneous
import XMonad
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)	-- To Change Keybindings
import XMonad.Hooks.EwmhDesktops	-- Enables EWMH Compliance
import XMonad.Util.Cursor	-- Set default cursor

-- Layouts
import XMonad.Layout.Groups.Helpers		-- Additional functions
import XMonad.Layout.Groups.Examples	-- Contain's Row of Columns layout

-- XMobar
import XMonad.Hooks.ManageDocks			-- Makes space for bar
import XMonad.Hooks.StatusBar			-- Workspace and other dynamic info
import XMonad.Hooks.StatusBar.PP		-- Workspace and other dynamic info
import XMonad.Util.Loggers				-- Highlight current active screen
import XMonad.Util.ClickableWorkspaces	-- Make workspaces clickable to switch

-- Window Placement
import XMonad.Hooks.ManageHelpers	-- FOr manageHook
import XMonad.Hooks.InsertPosition	-- Place new windows below focused window

-- Create toggling keybinds
import XMonad.Util.ActionCycle

-- Toggle Float
import qualified Data.Map as M
import qualified XMonad.StackSet as W

toggleFloat :: Window -> X()
toggleFloat w =
	windows (
		\s ->
			if M.member w (W.floating s)
			then W.sink w s
				else (W.float w (W.RationalRect (1/4) (1/4) (1/2) (1/2)) s)
	)

myPP = def {
	ppOrder = \(ws:_:t:_) -> [ws, t],
	ppSep = " | ",--  . xmobarColor "#707070" "",

	ppCurrent = xmobarColor "#00ff00" "" . wrap "[" "]",
	ppVisible = xmobarColor "#ffff00" "" . wrap "(" ")",
	ppUrgent = xmobarColor "#d00000" "",
	ppHiddenNoWindows = xmobarColor "#878787" "",

	ppTitle = shorten 60,

	ppExtras = [
		-- logWhenActive ScreenId (logConst "*")
	]
}

mySB = statusBarProp "xmobar" (clickablePP myPP)

main = xmonad $ withSB mySB $ ewmh $ docks $ def {
	terminal = "kitty",	-- Set terminal

	modMask = mod4Mask,	-- Set mod key (To Super_L)

	borderWidth			= 2,			-- Set border width of windows
	normalBorderColor	= "#000000",	-- Set border color for unfocussed windows
	focusedBorderColor	= "#777777",	-- Set border color for focussed windows

	focusFollowsMouse	= True,	-- Set if focus followed mouse

	startupHook = do {	-- Set programs to run at startup
		setDefaultCursor xC_left_ptr;
		spawn "pkill xmobar; xmobar $HOME/.config/xmobar/xmobar.config";
		spawn "feh --bg-scale $HOME/.config/xmonad/wallpaper.jpg";
	},

	layoutHook = avoidStruts (	-- Sets all available layouts
		rowOfColumns |||
		Full
	),

	manageHook = composeOne [
		isDialog -?> doCenterFloat
	]
}
	`removeKeysP` [ -- Remove unused keybindings:
		"M-S-<Return>",	-- Open terminal
		"M-p",			-- Open dmenu

		"M-S-c",	-- Kill foccussed window

		"M-q",	-- Recompile and restart xmonad
		"M-n",	-- Go to next window in StackSet
		"M-k"	-- Go to previous window in StackSet
	]
	`additionalKeysP` [
		---- Shortcuts ----
		("M-<Return>",	spawn "kitty"),		-- Open terminal
		("M-w",			spawn "librewolf"),	-- Open browser

		("M-<Space>",	spawn "dmenu_run -nb '#000000'"),	-- Open dmenu
		("M-q",			kill),								-- Kill focussed window

		("M-S-r",	spawn "xmonad --recompile; xmonad --restart"),	-- Recompile and restart xmonad

		-- Speaker
		("<XF86AudioMute>",			spawn "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),	-- Toggle mute audio ("<XF86AudioRaiseVolume>",	spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"),		-- Increase volume
		("<XF86AudioRaiseVolume>",	spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"),		-- Decrease volume
		("<XF86AudioLowerVolume>",	spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),		-- Decrease volume
		-- Microphone
		("S-<XF86AudioMute>",			spawn "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),	-- Toggle mute audio
		("S-<XF86AudioRaiseVolume>",	spawn "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+"),	-- Increase volume
		("S-<XF86AudioLowerVolume>",	spawn "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-"),	-- Decrease volume
		-- Brightness
		("<XF86MonBrightnessDown>",	spawn "brightnessctl set 1%-"),	-- Decrease brigntness
		("<XF86MonBrightnessUp>",	spawn "brightnessctl set +1%"),	-- Increase brightness
		-- Print Screen
		("<Print>", spawn "maim -u -s | xclip -selection clipboard -t image/png"),
		("M-<Print>", spawn "maim -u -s ~/media/screenshots/$(date +%s).png"),

		-- Switch keyboard layouts
		("M-C-<Space>", cycleAction "changeKeyboardLayout" [ spawn "setxkbmap us", spawn "xkbcomp ~/colemak.xkb $DISPLAY" ]),


		---- Navigation ----
		-- Change Layout
		("M-C-<Tab>", sendMessage NextLayout),
		-- Float
		("M-f", withFocused toggleFloat),	-- Toggle Float
		("M-C-f", toggleFocusFloat),		-- Toggle focus betwen tiled and floating windows

		-- Change Window Focus
		("M-n", focusGroupUp),		-- Move focus to left window
		("M-e", focusDown),			-- Move focus to down window
		("M-i", focusUp),			-- Move focus to up window
		("M-o", focusGroupDown),	-- Move focus to right window

		-- Window Resizing
		("M-C-n", zoomColumnOut),	-- Increase window height
		("M-C-e", zoomWindowOut),	-- Increase window height
		("M-C-i", zoomWindowIn),	-- Increase window height
		("M-C-o", zoomColumnIn),	-- Increase window width

		("M-m", toggleWindowFull *> toggleColumnFull),	-- Window takes full screen area
		("M-S-m", sendMessage ToggleStruts),			-- Toggles bar visibility
		("M-C-m", toggleWindowFull),					-- Window takes full column height

		-- Window Movement
		("M-S-n", moveToGroupUp(False)),	-- Move window left
		("M-S-e", swapDown),				-- Move window down
		("M-S-i", swapUp),					-- Move window up
		("M-S-o", moveToGroupDown(False))	-- Move window right
	]

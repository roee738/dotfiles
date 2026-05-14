local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"

-- Applications
hl.bind("SUPER + W",         hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + Q",         hl.dsp.window.close())
hl.bind("SUPER + ESCAPE",    hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + X",         hl.dsp.exec_cmd(menu))
hl.bind("SUPER + A",         hl.dsp.exec_cmd("zen-browser"))
hl.bind("SUPER + Z",         hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + C",         hl.dsp.exec_cmd("obsidian"))
hl.bind("SUPER + S",         hl.dsp.exec_cmd("code"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("killall waybar && waybar"))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind("SUPER + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P",         hl.dsp.window.pseudo())
hl.bind("SUPER + J",         hl.dsp.layout("togglesplit"))
hl.bind("SUPER + L",         hl.dsp.exec_cmd("~/.local/bin/power-menu.sh"))
hl.bind("Print",             hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Downloads/$(date +%Y%m%d)-screenshot.png'))

-- Focus movement
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down"  }))

-- Window movement
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "down"  }))

-- Switch workspaces and move windows with SUPER + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Move/resize windows with mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media & brightness keys
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && ~/.local/bin/volume-notify.sh"),    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%- && ~/.local/bin/volume-notify.sh"),    { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ~/.local/bin/volume-notify.sh"),           { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                                         { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5% && ~/.local/bin/brightness-notify.sh"),                           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- && ~/.local/bin/brightness-notify.sh"),                           { locked = true, repeating = true })

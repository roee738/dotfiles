hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Remove border and gaps when only one tiled window is open
hl.workspace_rule({ workspace = "w[1]", gaps_out = 0, gaps_in = 0, border_size = 0 })

-- Floaters
hl.window_rule({ match = { class = "qalculate-gtk" }, float = true, persistent_size = true, center = true })
hl.window_rule({ match = { class = "nwg-look" }, float = true, persistent_size = true, center = true })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, persistent_size = true, center = true })

-- Float system dialogs
hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true, persistent_size = true, center = true })
-- Picture-in-picture video
hl.window_rule({ match = { title = "Picture-in-Picture" }, float = true, pin = true, size = {400, 225}, keep_aspect_ratio = true, move = { "monitor_w-window_w-20", "monitor_h-window_h-20" } })

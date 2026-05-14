hl.env("XCURSOR_THEME",    "Breeze_Light")
hl.env("HYPRCURSOR_THEME", "Breeze_Light")
hl.env("XCURSOR_SIZE",     "24")
hl.env("HYPRCURSOR_SIZE",  "24")
hl.env("GDK_SCALE",        "1.25")

-- XWayland
hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})

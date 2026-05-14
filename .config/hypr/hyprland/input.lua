hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "caps:escape",

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

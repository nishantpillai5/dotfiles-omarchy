-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Dell AW3423DWF ultrawide (primary): 165Hz, HDR on
hl.monitor({ output = "DP-2", mode = "3440x1440@165", position = "0x0", scale = omarchy_monitor_scale, supports_hdr = 1 })

-- WSD WaveShare-119 e-ink: rotated 270° into a 1480x320 strip below the ultrawide
hl.monitor({ output = "HDMI-A-3", mode = "320x1480@57.68", position = "0x1440", scale = 1.0, transform = 1 })

-- Pin the e-ink strip to the last workspace (20 = highest Hyprland workspace number)
-- so it always shows up as the final workspace in the list.
hl.workspace_rule({ workspace = "20", monitor = "HDMI-A-3", default = true, persistent = true })

-- Fallback for other monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

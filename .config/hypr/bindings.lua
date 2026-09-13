-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- ===========================================================================
-- Ported from the old Nix hyprland.conf (github.com/nishantpillai5/dotfiles)
-- ===========================================================================

-- --- Gap 1: numpad workspace switch/move (old: mod + KP_*) -----------------
for workspace = 1, 9 do
  o.bind("SUPER + KP_" .. workspace, "Switch to workspace " .. workspace,
    hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + KP_" .. workspace, "Move window to workspace " .. workspace,
    hl.dsp.window.move({ workspace = tostring(workspace) }))
end
o.bind("SUPER + KP_0", "Switch to workspace 10", hl.dsp.focus({ workspace = "10" }))
o.bind("SUPER + SHIFT + KP_0", "Move window to workspace 10", hl.dsp.window.move({ workspace = "10" }))

-- Old config also mapped the numpad cursor cluster (End/Down/Next/... = 1..10).
local kp_cluster = {
  { "KP_End", 1 }, { "KP_Down", 2 }, { "KP_Next", 3 }, { "KP_Left", 4 }, { "KP_Begin", 5 },
  { "KP_Right", 6 }, { "KP_Home", 7 }, { "KP_Up", 8 }, { "KP_Prior", 9 }, { "KP_Insert", 10 },
}
for _, entry in ipairs(kp_cluster) do
  o.bind("SUPER + " .. entry[1], "Switch to workspace " .. entry[2],
    hl.dsp.focus({ workspace = tostring(entry[2]) }))
  o.bind("SUPER + SHIFT + " .. entry[1], "Move window to workspace " .. entry[2],
    hl.dsp.window.move({ workspace = tostring(entry[2]) }))
end

-- --- Gap 3: move active window to previous/next monitor --------------------
-- (Old: mod+ctrl+shift+H/L. Omarchy only had *workspace*-to-monitor moves.)
o.bind("SUPER + CTRL + SHIFT + H", "Move window to next monitor", hl.dsp.window.move({ monitor = "+1" }))
o.bind("SUPER + CTRL + SHIFT + L", "Move window to previous monitor", hl.dsp.window.move({ monitor = "-1" }))

-- --- Gap 4: resize with arrows (old: mod + arrows, ±50) ---------------------
-- Replaces Omarchy's arrow *focus* binds; focus moves to SUPER+H/J/K/L below.
for _, arrow in ipairs({ "LEFT", "RIGHT", "UP", "DOWN" }) do
  hl.unbind("SUPER + " .. arrow)
end
for _, entry in ipairs({ { "LEFT", -50, 0 }, { "RIGHT", 50, 0 }, { "UP", 0, -50 }, { "DOWN", 0, 50 } }) do
  o.bind("SUPER + " .. entry[1], "Resize window " .. entry[1]:lower(),
    hl.dsp.window.resize({ x = entry[2], y = entry[3], relative = true }))
end
-- Omarchy's richer resize scheme stays on MINUS/EQUAL (SUPER, +ALT little, +CTRL a lot).

-- --- Gap 5: vim-style focus with SUPER+H/J/K/L (old: mod + H/J/K/L) ---------
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
for _, entry in ipairs({ { "H", "l" }, { "L", "r" }, { "J", "d" }, { "K", "u" } }) do
  o.bind("SUPER + " .. entry[1], "Focus window " .. entry[2],
    hl.dsp.focus({ direction = entry[2] }))
end

-- Vim-style window swap (old: mod+shift+H/J/K/L). Omarchy's own swap is on SUPER+SHIFT+arrows.
for _, entry in ipairs({ { "H", "l" }, { "L", "r" }, { "J", "d" }, { "K", "u" } }) do
  o.bind("SUPER + SHIFT + " .. entry[1], "Swap window " .. entry[2],
    hl.dsp.window.swap({ direction = entry[2] }))
end

-- --- --- Re-homes for the Omarchy features displaced above ---------------------
o.bind("SUPER + Z", "Toggle window split", hl.dsp.layout("togglesplit")) -- was SUPER+J; matches old mod+Z
o.bind("SUPER + I", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle") -- was SUPER+L
hl.unbind("SUPER + SHIFT + SLASH") -- 1Password launcher; not used
o.bind("SUPER + SHIFT + SLASH", "Keybindings", "omarchy-menu-keybindings") -- was SUPER+K; ? = SHIFT+SLASH

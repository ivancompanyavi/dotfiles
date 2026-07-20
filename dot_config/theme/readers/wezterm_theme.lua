-- ─────────────────────────────────────────────────────────────────────────
-- WezTerm theme reader. Reads the active theme (pointer file) + the current
-- macOS appearance, looks up the matching variant in the JSON registry, and
-- returns the WezTerm built-in scheme name + a tab-bar background from roles.
-- Named *_theme to avoid shadowing the real `wezterm` module on package.path.
-- ─────────────────────────────────────────────────────────────────────────
local wezterm = require("wezterm")

local M = {}

local HOME = os.getenv("HOME")
local THEME_HOME = HOME .. "/.config/theme"
local STATE = (os.getenv("XDG_STATE_HOME") or (HOME .. "/.local/state")) .. "/theme"
M.pointer = STATE .. "/current"

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*a")
  f:close()
  return s
end

local function current_name()
  local s = read_file(M.pointer)
  if s then s = s:gsub("%s+", "") end
  if s and s ~= "" and io.open(THEME_HOME .. "/registry/" .. s .. ".json", "r") then
    return s
  end
  return "tokyonight"
end

-- appearance is WezTerm's get_appearance() string, e.g. "Dark"/"Light".
function M.spec(appearance)
  local polarity = (appearance and appearance:find("Dark")) and "dark" or "light"
  -- Safe defaults reproduce the pre-theme-system look.
  local scheme = (polarity == "dark") and "Tokyo Night Storm (Gogh)" or "Tokyo Night Day"
  local bg = (polarity == "dark") and "#1a1b26" or "#e1e2e7"

  local raw = read_file(THEME_HOME .. "/registry/" .. current_name() .. ".json")
  if raw then
    local ok, data = pcall(wezterm.json_parse, raw)
    if ok and data and data.variants then
      local v = data.variants[polarity] or data.variants.dark or data.variants.light
      if v then
        if v.wezterm and v.wezterm ~= "" then scheme = v.wezterm end
        if v.roles and v.roles.bg then bg = v.roles.bg end
      end
    end
  end
  return { color_scheme = scheme, tab_bar_bg = bg }
end

return M

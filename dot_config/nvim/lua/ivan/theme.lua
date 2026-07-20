-- ─────────────────────────────────────────────────────────────────────────
-- Neovim theme reader. Reads the active theme (pointer file) from the shared
-- ~/.config/theme registry and applies the matching colorscheme for the current
-- macOS polarity.
--
-- Behaviour (per design):
--   • Theme *name* changes take effect in NEW nvim sessions (or :ThemeReload).
--   • Light/dark *polarity* follows macOS live via auto-dark-mode.nvim, which
--     calls M.apply("dark"|"light") on change.
-- ─────────────────────────────────────────────────────────────────────────
local M = {}

local uv = vim.uv or vim.loop
local HOME = os.getenv("HOME")
local THEME_HOME = HOME .. "/.config/theme"
local POINTER = (os.getenv("XDG_STATE_HOME") or (HOME .. "/.local/state")) .. "/theme/current"

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*a")
  f:close()
  return s
end

local function current_name()
  local s = read_file(POINTER)
  if s then s = vim.trim(s) end
  if s and s ~= "" and uv.fs_stat(THEME_HOME .. "/registry/" .. s .. ".json") then
    return s
  end
  return "tokyonight"
end

-- macOS appearance → "dark" | "light".
function M.macos_polarity()
  local out = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  return (out and out:lower():find("dark")) and "dark" or "light"
end

-- The nvim spec for the active theme + polarity, with a tokyonight fallback.
local function load_spec(polarity)
  local default = {
    module = "tokyonight",
    colorscheme = (polarity == "dark") and "tokyonight-storm" or "tokyonight-day",
    background = polarity,
    opts = { style = (polarity == "dark") and "storm" or "day", transparent = true },
  }
  local raw = read_file(THEME_HOME .. "/registry/" .. current_name() .. ".json")
  if not raw then return default end
  local ok, data = pcall(vim.json.decode, raw)
  if not ok or not data or not data.variants then return default end
  local v = data.variants[polarity] or data.variants.dark or data.variants.light
  if not v or not v.nvim then return default end
  return v.nvim
end

-- Apply the active theme for the given polarity (defaults to macOS polarity).
function M.apply(polarity)
  polarity = polarity or M.macos_polarity()
  local spec = load_spec(polarity)
  if spec.background then vim.o.background = spec.background end
  if spec.module then
    pcall(function() require(spec.module).setup(spec.opts or {}) end)
  end
  local ok = pcall(vim.cmd.colorscheme, spec.colorscheme)
  if not ok then
    -- Last resort: never leave the editor un-themed.
    pcall(vim.cmd.colorscheme, "tokyonight-storm")
  end
end

function M.setup()
  -- Initial apply for this session (reads the pointer once).
  M.apply(M.macos_polarity())

  -- Re-read the pointer on demand (theme name changes are new-session by design).
  vim.api.nvim_create_user_command("ThemeReload", function()
    M.apply(M.macos_polarity())
    vim.notify("Theme reloaded: " .. current_name(), vim.log.levels.INFO)
  end, { desc = "Re-read the active theme pointer and apply it" })

  -- Live polarity following via auto-dark-mode.nvim (if present).
  local ok, autodark = pcall(require, "auto-dark-mode")
  if ok then
    autodark.setup({
      set_dark_mode = function() M.apply("dark") end,
      set_light_mode = function() M.apply("light") end,
    })
  end
end

return M

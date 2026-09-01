-- ========================================================================== --
-- ==                           NVIM SETUP (LINUX)                         == --
-- ========================================================================== --
-- lives in ~/.config/nvim/init.lua

vim.opt.shortmess:append("I")                      -- Disable splash screen
vim.g.mapleader      = " "                         -- Leader key
vim.g.maplocalleader = " "                         -- Local leader
vim.g.editorconfig   = false                       -- Don't let .editorconfig re-add tabs

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {                                                -- Theme
    "tanvirtin/monokai.nvim",
    priority = 1000,
    lazy     = false,
    config   = function()
      local monokai = require("monokai")
      monokai.setup({ palette = monokai.soda, italics = false })
    end,
  },
  {                                                -- hex values coloured
    "nvchad/nvim-colorizer.lua",
    opts = { user_default_options = { names = false } },
  },
 -- {                                                -- comment toggle
 --    "numtostr/comment.nvim",
 --    config = true,
 --  },
  {                                                -- multi cursor, sublime/n++ style
    "mg979/vim-visual-multi",
    branch = "master",
    lazy   = false,
    init   = function()
      vim.g.VM_leader = "\\"                       -- keep VM off your space leader
      vim.g.VM_maps   = {
        ["Add Cursor Down"] = "<M-J>",             -- alt+shift+j
        ["Add Cursor Up"]   = "<M-K>",             -- alt+shift+k
      }
    end,
  },
})


-- ========================================================================== --
-- ==                           GENERAL OPTIONS                            == --
-- ========================================================================== --
local opt = vim.opt

opt.clipboard      = "unnamedplus"                 -- System clipboard
opt.cmdheight      = 0                             -- Hide command line
opt.cursorline     = true                          -- Highlight active line
opt.expandtab      = true                          -- Convert tabs to spaces
opt.list           = false                         -- Whitespace characters
opt.mouse          = ""                            -- Disable mouse
opt.number         = true                          -- Show line numbers
opt.relativenumber = true                          -- Show relative numbers
opt.scrolloff      = 1337                          -- Vertical scroll offset
opt.shiftwidth     = 2                             -- Indent size
opt.sidescrolloff  = 16                            -- Horizontal scroll offset
opt.signcolumn     = "no"                          -- No sign/gutter column
opt.smarttab       = true                          -- Use shiftwidth for tabs
opt.softtabstop    = 2                             -- Backspace deletes spaces
opt.swapfile       = false                         -- Disable swap files
opt.tabstop        = 5                             -- Tab width
opt.termguicolors  = true                          -- True color support
opt.undofile       = true                          -- Enable undo file
opt.wrap           = false                         -- No line wrapping

local undodir      = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")

opt.undodir        = undodir
opt.listchars      = { tab = "--", trail = "·", space = "~", eol = "$", nbsp = "~" }
opt.guicursor      = "n-v-c:block-cursor/lcursor-blinkon1000-blinkoff500,i-ci-ve:block-cursor/lcursor-blinkon1000-blinkoff200"

-- ========================================================================== --
-- ==                           THEME                                      == --
-- ========================================================================== --
-- NOTE: no `colorscheme monokai_soda` here on purpose - it re-runs setup()
-- with italics=true and undoes the plugin config above.
local hl = vim.api.nvim_set_hl
local bg = "#26292C"                               -- monokai soda base2 (old signcolumn grey)

hl(0, "Normal",         { bg = bg })               -- Editor background
hl(0, "NormalFloat",    { bg = bg })               -- Floating windows
hl(0, "CursorLine",     { bg = "#32363A" })        -- Highlight active line
hl(0, "LineNr",         { fg = "#00ffff" })        -- Line numbers
hl(0, "CursorLineNr",   { fg = "#ffff00", bold = true })
hl(0, "Search",         { fg = "#111111", bg = "#ff4f00" })
hl(0, "Visual",         { fg = "#111111", bg = "#00ffff" })
hl(0, "YankHighlight",  { fg = "#000000", bg = "#FF00FF" })
hl(0, "MsgArea",        { fg = "#BFFF00", bg = "#000000" })
-- (dropped "Cmdline" - not a real highlight group, MsgArea is the one that works)

-- Status Line
function _G.get_statusline()
  local n = vim.api.nvim_buf_get_name(0)
  return (n == "" and "[No Name]" or n) .. " %m %= %{&filetype} | Col:%2c | Line:%3l | %3p%% "
end
vim.opt.statusline = "%!v:lua.get_statusline()"

-- Colourful Modes
local function update_mode_color()
  local mode    = vim.api.nvim_get_mode().mode
  local mode_hl = { fg = "#BFFF00", bold = true }  -- Lime green on per-mode bg

  if     mode == "n"                                  then mode_hl.bg = "#333333"
  elseif mode == "i"                                  then mode_hl.bg = "#2E6B2E"
  elseif mode == "v" or mode == "V" or mode == "\22"  then mode_hl.bg = "#2B4E80"
  elseif mode == "R"                                  then mode_hl.bg = "#7A2B2B"
  elseif mode == "t"                                  then mode_hl.bg = "#6B4A17"
  end

  vim.api.nvim_set_hl(0, "StatusLine", mode_hl)
end

-- Yank Duration
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() (vim.hl or vim.highlight).on_yank({ higroup = "YankHighlight", timeout = 250 }) end,
})

-- Refresh on events
vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter", "BufWinEnter" }, { callback = update_mode_color })

-- Curve'y
local function kill_italics()
  local groups = vim.fn.getcompletion("", "highlight")
  for _, name in ipairs(groups) do
    if not name:find("comment") then
      local g = vim.api.nvim_get_hl(0, { name = name, link = false })
      if g.italic then
        g.italic = false
        vim.api.nvim_set_hl(0, name, g)
      end
    end
  end
end
kill_italics()
vim.api.nvim_create_autocmd("ColorScheme", { callback = kill_italics })

-- ========================================================================== --
-- ==                              KEYBINDS                                == --
-- ========================================================================== --
local keymap = vim.keymap.set

-- Escape clears search highlight (VM installs its own buffer-local Esc)
keymap("n", "<Esc>", "<Cmd>nohlsearch<CR>", { silent = true })

-- Toggle Whitespace
keymap("n", "<Leader>`", function()
  vim.opt_local.list = not vim.opt_local.list:get()
end, { desc = "Toggle Whitespace" })

-- Toggle Search Highlight
keymap("n", "<Leader>h", "<Cmd>set hlsearch!<CR>", { silent = true, desc = "Toggle Search Highlight" })

-- Select All
keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Commenting
for _, k in ipairs({ "<C-_>", "<C-/>" }) do
  keymap("n", k, "gcc", { remap = true })
  keymap("v", k, "gc",  { remap = true })
end

-- Line indentation
keymap("n", "<Tab>",   ">>",   { noremap = true, silent = true })
keymap("n", "<S-Tab>", "<<",   { noremap = true, silent = true })
keymap("v", "<Tab>",   ">gv",  { noremap = true, silent = true })
keymap("v", "<S-Tab>", "<gv",  { noremap = true, silent = true })

-- Save
keymap({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("write!")
  if vim.api.nvim_get_mode().mode ~= "n" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end, { desc = "Force Save" })

-- Detab: every tab in the buffer -> spaces, 2-wide
keymap("n", "<Leader><Tab>", function()
  local view          = vim.fn.winsaveview()
  vim.bo.expandtab    = true
  vim.bo.tabstop      = 2
  vim.bo.softtabstop  = 2
  vim.bo.shiftwidth   = 2
  vim.cmd("silent! %retab")
  vim.fn.winrestview(view)
end, { desc = "Tabs -> 2 spaces (retab)" })
 
-- Detab, literal: 1 tab == exactly 2 spaces, column stops be damned
keymap("n", "<Leader><S-Tab>", [[:%s/\t/  /g<CR><Cmd>nohlsearch<CR>]], { desc = "Tabs -> 2 spaces (literal)" })

-- Move lines up/down
keymap("n", "<M-j>", "<Cmd>silent! m .+1<CR>", { silent = true, desc = "Move line down" })
keymap("n", "<M-k>", "<Cmd>silent! m .-2<CR>", { silent = true, desc = "Move line up" })
keymap("v", "<M-j>", ":silent! m '>+1<CR>gv",  { silent = true, desc = "Move block down" })
keymap("v", "<M-k>", ":silent! m '<-2<CR>gv",  { silent = true, desc = "Move block up" })

-- Commenting
for _, k in ipairs({ "<C-_>", "<C-/>" }) do
  keymap("n", k, "gcc", { remap = true })
  keymap("v", k, "gc",  { remap = true })
end

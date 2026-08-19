-- ── Options ──────────────────────────────────────────────────────────────────
vim.opt.number         = true          -- line numbers
vim.opt.relativenumber = true          -- relative line numbers (easy jumps)
vim.opt.cursorline     = true          -- highlight current line
vim.opt.signcolumn     = "yes"         -- always show sign column (no jitter)
vim.opt.wrap           = true          -- wrap long lines
vim.opt.linebreak      = true          -- break at word boundaries
vim.opt.scrolloff      = 16            -- keep 16 lines above/below cursor
vim.opt.sidescrolloff  = 8

-- Indentation
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.expandtab      = true          -- spaces instead of tabs
vim.opt.smartindent    = true

-- Search
vim.opt.ignorecase     = true
vim.opt.smartcase      = true          -- case-sensitive if uppercase used
vim.opt.hlsearch       = false         -- don't highlight after search done
vim.opt.incsearch      = true

-- Appearance
vim.opt.termguicolors  = true          -- full color support
vim.opt.showmode       = false         -- mode shown in statusline instead
vim.opt.splitright     = true          -- vertical splits open right
vim.opt.splitbelow     = true          -- horizontal splits open below

-- Behaviour
vim.opt.undofile       = true          -- persistent undo across sessions
vim.opt.swapfile       = false
vim.opt.clipboard      = "unnamedplus" -- use system clipboard
vim.opt.updatetime     = 250           -- faster diagnostics / cursorhold

-- ── Keymaps ───────────────────────────────────────────────────────────────────
vim.g.mapleader = " "                  -- Space as leader

local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Don't clobber clipboard when pasting over a visual selection
map("x", "<leader>p", '"_dP')

-- Open current file's directory in Finder
map("n", "<leader>o", function()
  vim.fn.system("open " .. vim.fn.expand("%:p:h"))
end)

-- Cmd+C — copy without cutting (visual: copy selection, normal: copy line)
map("v", "<D-c>", '"+y')
map("n", "<D-c>", '"+yy')

-- Select all (Ctrl+A)
map({ "n", "v" }, "<C-a>", "ggVG")

-- Clear search highlight in normal mode; ESC in insert mode exits and saves
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("i", "<Esc>", "<Esc><cmd>silent! w<CR>")

-- Save with Ctrl+S (all modes)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>")

-- Quit
map("n", "<leader>q", "<cmd>q<CR>")

-- ── Plugins (via lazy.nvim) ───────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ── Colorscheme ─────────────────────────────────────────────────────────────
  {
    "rose-pine/neovim",
    name     = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({ variant = "moon" })
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  -- ── Statusline ──────────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "rose-pine" } })
    end,
  },

  -- ── Snacks — file picker, grep, buffer switcher ──────────────────────────────
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy     = false,
    ---@type snacks.Config
    opts = {
      -- enable the pickers we use; disable the rest
      picker  = { enabled = true },
      notifier = { enabled = true },
      bigfile  = { enabled = true },
    },
    keys = {
      { "<leader>f", function() Snacks.picker.files() end,   desc = "Find files" },
      { "<leader>s", function() Snacks.picker.grep() end,    desc = "Grep (live)" },
      { "<leader>b", function() Snacks.picker.buffers() end, desc = "Buffers" },
    },
  },

  -- ── Oil — file tree as editable buffer ──────────────────────────────────────
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        -- show hidden files by default (toggle with g.)
        view_options = { show_hidden = true },
        -- open oil in a floating window
        float = { padding = 2 },
      })
      map("n", "<leader>e", "<cmd>Oil --float<CR>", { desc = "Open parent dir (Oil)" })
    end,
  },

  -- ── Neogit — full-featured git UI ───────────────────────────────────────────
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",  -- optional but recommended for richer diffs
    },
    config = function()
      require("neogit").setup({})
      map("n", "<leader>g", "<cmd>Neogit<CR>", { desc = "Open Neogit" })
    end,
  },

  -- ── Git signs in the gutter + inline blame ───────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay          = 500,
          virt_text_pos  = "eol",
        },
      })
    end,
  },

  -- ── Syntax highlighting ──────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      configs.setup({
        ensure_installed = {
          "lua", "python", "javascript", "typescript",
          "bash", "json", "markdown",
        },
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },

  -- ── Auto pairs (brackets, quotes) ────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = true,
  },

  -- ── Comment toggle (gcc / gc in visual) ──────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- ── Which-key (shows keybindings when you pause) ──────────────────────────────
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    config = true,
  },

}, {})

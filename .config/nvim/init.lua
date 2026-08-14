-- ── Options ──────────────────────────────────────────────────────────────────
vim.opt.number         = true          -- line numbers
vim.opt.relativenumber = true          -- relative line numbers (easy jumps)
vim.opt.cursorline     = true          -- highlight current line
vim.opt.signcolumn     = "yes"         -- always show sign column (no jitter)
vim.opt.wrap           = true          -- wrap long lines
vim.opt.linebreak      = true          -- break at word boundaries
vim.opt.scrolloff      = 8             -- keep 8 lines above/below cursor
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

-- Don't lose clipboard when pasting over selection
map("x", "<leader>p", '"_dP')

-- Open current file's directory in Finder
map("n", "<leader>o", function()
  vim.fn.system("open " .. vim.fn.expand("%:p:h"))
end)

-- Cmd+C — copy without cutting (visual: copy selection, normal: copy line)
map("v", "<D-c>", '"+y')
map("n", "<D-c>", '"+yy')

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save with Ctrl+S
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

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "tokyonight" } })
    end,
  },

  -- Fuzzy finder (Ctrl+P files, leader+/ grep)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      map("n", "<C-p>",      builtin.find_files)
      map("n", "<leader>/",  builtin.live_grep)
      map("n", "<leader>b",  builtin.buffers)
    end,
  },

  -- File tree (leader+e)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.set("n", "<leader>o", function()
            local node = api.tree.get_node_under_cursor()
            local path = node.type == "directory" and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
            vim.fn.system("open " .. vim.fn.shellescape(path))
          end, { buffer = bufnr })
        end,
      })
      map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      configs.setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "bash", "json", "markdown" },
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },

  -- Auto pairs (brackets, quotes)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comment toggle (gcc / gc in visual)
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Which-key (shows keybindings when you pause)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

}, {})

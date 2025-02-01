return {
    -- Lazy.nvim manages itself
    { "folke/lazy.nvim" },

    -- Add other plugins here
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { "nvim-lua/plenary.nvim" },
    { "neovim/nvim-lspconfig" },

    -- Aesthetic plugins
    { "hoob3rt/lualine.nvim" },
    { "kyazdani42/nvim-web-devicons" },
}

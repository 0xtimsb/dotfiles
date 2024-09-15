local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- lazy.nvim
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "cpp" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  { "windwp/nvim-autopairs", config = true },
  { "numToStr/Comment.nvim", config = true },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = { style = "night" } },
}, {
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },
})

-- global options
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.fileencoding = "utf-8"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.belloff = "all"

-- window-local
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

-- buffer-local
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- syntax highlighting
vim.cmd('syntax on')

-- colorscheme
vim.cmd[[colorscheme tokyonight]]

-- c++
--vim.api.nvim_set_keymap('n', '<C-b>', ':w<CR>:!g++-12 % -o %:r && ./%:r < input.txt; rm %:r<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-b>', ':w<CR>:!LOCAL_DEBUG=1 g++-12 % -o %:r && ./%:r < input.txt; rm %:r<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-b>', ':w<CR>:!env LOCAL_DEBUG=1 g++-12 % -o %:r && ./%:r < input.txt; rm %:r<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-b>', ':w<CR>:!g++-12 -DLOCAL_DEBUG % -o %:r && ./%:r < input.txt; rm %:r<CR>', { noremap = true, silent = true })

local function open_input_split()
    local width = vim.o.columns
    local split_width = math.floor(width * 0.3)
    vim.cmd("rightbelow " .. split_width .. "vsplit input.txt")
end

local function safe_close_related_buffer(pattern)
    vim.defer_fn(function()
        local related_buf = nil
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name:match(pattern) then
                related_buf = buf
                break
            end
        end

        if related_buf then
            pcall(vim.api.nvim_buf_delete, related_buf, {force = true})
        end

        -- Check if only empty buffers are left
        local only_empty_buffers = true
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
                only_empty_buffers = false
                break
            end
        end

        if only_empty_buffers then
            vim.cmd('quit')
        end
    end, 0)
end

local augroup = vim.api.nvim_create_augroup("CPPInputGroup", { clear = true })

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = augroup,
    pattern = "*.cpp",
    callback = open_input_split
})

vim.api.nvim_create_autocmd("BufWinLeave", {
    group = augroup,
    pattern = "*.cpp",
    callback = function()
        safe_close_related_buffer("input.txt$")
    end
})

vim.api.nvim_create_autocmd("BufWinLeave", {
    group = augroup,
    pattern = "input.txt",
    callback = function()
        safe_close_related_buffer("%.cpp$")
    end
})

-- switch
vim.api.nvim_set_keymap('n', '<leader>b', ':lua ToggleBuffer()<CR>', {noremap = true, silent = true})

function ToggleBuffer()
    local alt_buf = vim.fn.bufnr('#')
    if alt_buf ~= -1 then
        vim.api.nvim_set_current_buf(alt_buf)
    else
        vim.cmd('bnext')
    end
end

local config = function()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "bash",
      "bibtex",
      "dockerfile",
      "go",
      "gomod",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "python",
      "toml",
      "typescript",
      "yaml"
    },
    highlight = {enable = true},
    indent = {enable = true}
  }
end

return {config = config}

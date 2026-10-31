-- Loaded by the CI smoke jobs against each packaged Neovim. Every require()
-- here only succeeds if the vendored runtimepath resolves, so a silent
-- regression in the portable rewrite fails loudly.
local expected = {
  "telescope",
  "lualine",
  "gitsigns",
  "which-key",
}

local failed = {}

for _, name in ipairs(expected) do
  if not pcall(require, name) then
    table.insert(failed, "plugin not loadable: " .. name)
  end
end

if not pcall(vim.cmd.colorscheme, "catppuccin") then
  table.insert(failed, "colorscheme not loadable: catppuccin")
end

if #failed > 0 then
  io.stderr:write(table.concat(failed, "\n") .. "\n")
  os.exit(1)
end

print("nixvim bundle ok")

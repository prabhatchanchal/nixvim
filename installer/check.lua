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

-- the loader's own message names the missing module, which is the difference
-- between "something did not resolve" and a fixable diagnosis
local function attempt(fn, arg)
  local ok, err = pcall(fn, arg)
  if ok then
    return
  end
  return (tostring(err):gsub("\n.*", "", 1))
end

for _, name in ipairs(expected) do
  local err = attempt(require, name)
  if err then
    table.insert(failed, name .. ": " .. err)
  end
end

local scheme = attempt(vim.cmd.colorscheme, "catppuccin")
if scheme then
  table.insert(failed, "catppuccin: " .. scheme)
end

if #failed > 0 then
  io.stderr:write(table.concat(failed, "\n") .. "\n")
  os.exit(1)
end

print("nixvim bundle ok")

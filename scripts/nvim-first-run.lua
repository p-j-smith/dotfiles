-- Headless first launch of Neovim. Installs what LazyVim would otherwise install the first
-- time you open a file (Mason tools, language servers, treesitter parsers) and waits for it.
--
-- chezmoi's Neovim script runs it:  nvim --headless "+Lazy! restore" "+luafile scripts/nvim-first-run.lua"
--
-- Exits non-zero if anything failed to install.

local timeout_ms = 15 * 60 * 1000
local poll_ms = 1000

local function say(msg)
  io.stdout:write(msg .. "\n")
end

local registry = require("mason-registry")

local failed = {}
registry:on("package:install:failed", function(pkg)
  failed[#failed + 1] = "mason: " .. pkg.name
end)

-- Language servers are normally installed when the first file is opened.
require("lazy").load({ plugins = { "nvim-lspconfig", "nvim-treesitter" } })
-- mason-lspconfig skips its `ensure_installed` in headless mode, so start those installs here.
require("mason-lspconfig.features.ensure_installed")()

local function mason_installing()
  local names = {}
  for _, pkg in ipairs(registry.get_all_packages()) do
    if pkg:is_installing() then
      names[#names + 1] = pkg.name
    end
  end
  return names
end

local function parsers_missing()
  local installed = require("nvim-treesitter").get_installed()
  return vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
  end, LazyVim.opts("nvim-treesitter").ensure_installed or {})
end

-- Installs start asynchronously, so wait until nothing is in progress for a few polls in a row.
local idle_polls = 0
local done = vim.wait(timeout_ms, function()
  if #mason_installing() == 0 and #parsers_missing() == 0 then
    idle_polls = idle_polls + 1
  else
    idle_polls = 0
  end
  return idle_polls >= 5
end, poll_ms)

for _, tool in ipairs(LazyVim.opts("mason.nvim").ensure_installed or {}) do
  if not registry.is_installed(tool) and not vim.tbl_contains(failed, "mason: " .. tool) then
    failed[#failed + 1] = "mason: " .. tool
  end
end
for _, lang in ipairs(parsers_missing()) do
  failed[#failed + 1] = "treesitter: " .. lang
end
if not done then
  for _, name in ipairs(mason_installing()) do
    failed[#failed + 1] = "mason (timed out): " .. name
  end
end

say(("Mason packages installed: %s"):format(table.concat(registry.get_installed_package_names(), ", ")))
if #failed > 0 then
  say("Not installed:\n  " .. table.concat(failed, "\n  "))
  vim.cmd("cquit 1")
else
  say("Neovim first run complete.")
  vim.cmd("quitall!")
end

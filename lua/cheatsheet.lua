local M = {}

local function generate_cheatsheet()
  local modes = { 'n', 'i', 'v', 'x', 'c', 't', 'o' }
  local mode_names = {
    n = "Normal",
    i = "Insert",
    v = "Visual",
    x = "Visual Block",
    c = "Command",
    t = "Terminal",
    o = "Operator Pending"
  }

  local lines = {
    "# Neovim Cheatsheet",
    "",
    "This cheatsheet is automatically generated from your active Neovim configuration.",
    "",
    "| Mode | Keybind | Action / Description |",
    "|------|---------|----------------------|",
  }

  local function escape_markdown(str)
    if not str then return "" end
    str = string.gsub(str, "|", "\\|")
    return str
  end

  local sorted_keymaps = {}
  
  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(keymaps) do
      if map.desc or map.rhs then
        map._mode = mode
        table.insert(sorted_keymaps, map)
      end
    end
  end

  table.sort(sorted_keymaps, function(a, b)
    if a._mode ~= b._mode then
      return a._mode < b._mode
    end
    return (a.lhs or "") < (b.lhs or "")
  end)

  for _, map in ipairs(sorted_keymaps) do
    local lhs = map.lhs or ""
    lhs = string.gsub(lhs, "<", "&lt;")
    lhs = string.gsub(lhs, ">", "&gt;")
    lhs = "`" .. lhs .. "`"
    
    local desc = map.desc
    if not desc then
      local rhs = map.rhs or ""
      if rhs == "" and map.callback then
        rhs = "<Lua Function>"
      end
      desc = rhs
    end

    table.insert(lines, string.format("| %s | %s | %s |", mode_names[map._mode] or map._mode, escape_markdown(lhs), escape_markdown(desc)))
  end

  -- Write to CHEATSHEET.md in config dir
  local config_dir = vim.fn.stdpath("config")
  local file_path = vim.fs.joinpath(config_dir, "CHEATSHEET.md")
  local file = io.open(file_path, "w")
  if file then
    for _, line in ipairs(lines) do
      file:write(line .. "\n")
    end
    file:close()
    vim.notify("Cheatsheet generated at " .. file_path, vim.log.levels.INFO)
    
    -- Open the generated file
    vim.cmd("edit " .. file_path)
    -- Optional: Use glow.nvim or render-markdown if available, else just set to markdown
    vim.bo.filetype = "markdown"
  else
    vim.notify("Failed to generate cheatsheet", vim.log.levels.ERROR)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("Cheatsheet", generate_cheatsheet, {
    desc = "Generate and open a beautiful Markdown cheatsheet of all current keybinds",
  })
end

return M

local function _GetSelectedTextCharWise()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  local selected_text = vim.api.nvim_buf_get_text(
      0,
      start_pos[1] - 1,
      start_pos[2],
      end_pos[1] - 1,
      end_pos[2] + 1,
      {}
  )
  return table.concat(selected_text)
end

local function _GetSelectedTextLineWise()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  local lines = vim.api.nvim_buf_get_lines(
    0,
    start_pos[1] - 1,
    end_pos[1],
    true
  )
  return table.concat(lines)
end

local function _GetSelectedTextBlockWise()
  -- Might not work when block is not selected starting from upper-left to lower-right corner.
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  local lines = {}
  for line = start_pos[1] - 1, end_pos[1] - 1 do
    local selected_part = vim.api.nvim_buf_get_text(
        0,
        line,
        start_pos[2],
        line,
        end_pos[2] + 1,
        {}
    )
    table.insert(lines, table.concat(selected_part))
  end
  return table.concat(lines)
end

local function _GetSelectedText()
  if "v" == vim.fn.visualmode() then
    return _GetSelectedTextCharWise()
  end
  if "V" == vim.fn.visualmode() then
    return _GetSelectedTextLineWise()
  end
  if "\22" == vim.fn.visualmode() then
    return _GetSelectedTextBlockWise()
  end
  return ""
end

local function _DecodeBase64String(base64_string)
  base64_string = string.gsub(base64_string, "%s+", "")
  local command = "echo " ..base64_string.. " | base64 -d"
  local handler = io.popen(command)
  local lines = {}
  if handler then
    handler:flush()
    for line in handler:lines() do
      table.insert(lines, line)
    end
  end
  return lines
end

local function _CreateWindowAndShowResult(output_lines)
  vim.cmd('vsplit')
  local new_window = vim.api.nvim_get_current_win()
  local new_buffer = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(new_buffer, 0, 0, true, output_lines)
  vim.api.nvim_win_set_buf(new_window, new_buffer)
end

local function DecodeBase64()
  local selected_text = _GetSelectedText()
  local output_lines = _DecodeBase64String(selected_text)
  _CreateWindowAndShowResult(output_lines)
end

return
{
  DecodeBase64 = DecodeBase64,
}


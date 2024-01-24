local function _GetLinesInBuffer()
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

local function _HasError(response_string)
  local error_string = '__FAIL__'
  if string.find(response_string, error_string) then
    return true
  end
  return false
end

local function _EncodeStringAsBase64(lines_to_encode)
  local temp_file_name = vim.fn.tempname()
  vim.fn.writefile(lines_to_encode, temp_file_name)
  -- There isn't a straightforward way to get the exit code of a command in lua
  -- 5.1, therefore using below approach.
  local command = "base64 --wrap 0 < " ..temp_file_name.. " || printf '__FAIL__'"
  local handler = io.popen(command)
  local output = ""
  if handler then
    handler:flush()
    output = handler:read("*all")
    if _HasError(output) then
      print("Command failed")
      print(output)
      output = ""
    end
    handler:close()
  end
  vim.fn.delete(temp_file_name)
  return output
end

local function _SaveResponseToUnnamedRegisterIfNotEmpty(response_string)
  if string.len(response_string) > 0 then
    -- Can also use the clipboard ("+") or selection ("*") registers if needed
    vim.fn.setreg("", response_string)
    print("Base64 encoded text was yanked.")
  end
end

function EncodeAsBase64()
  local text_to_encode = _GetLinesInBuffer()
  local encoded_text = _EncodeStringAsBase64(text_to_encode)
  _SaveResponseToUnnamedRegisterIfNotEmpty(encoded_text)
end

return
{
  EncodeAsBase64 = EncodeAsBase64,
}


if vim.g.loaded_nvim_external_base64 then
  return
end

if vim.fn.executable("base64") ~= 1 then
  vim.api.nvim_err_writeln("Could not find the base64 executable needed by the plugin.")
  return
end

vim.keymap.set(
    "v",
    "<Plug>(DecodeBase64)",
    '<esc><cmd>lua require("nvim-external-base64.decoder").DecodeBase64()<cr>',
    {
      desc = "Decode selected base64 string."
    }
)

vim.keymap.set(
    "n",
    "<Plug>(EncodeAsBase64)",
    '<esc><cmd>lua require("nvim-external-base64.encoder").EncodeAsBase64()<cr>',
    {
      desc = "Encode contents of the current buffer as base64 and yank the result."
    }
)

vim.g.loaded_nvim_external_base64 = true


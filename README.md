# Introduction
This is a basic lua plugin for neovim that feeds selected text to an external
command, and displays the result in a new buffer window. The contents of the
new temporary window can be modified, and sent back to the program. The result
is then yanked.

In this case the the plugin uses the base64 program for encoding and decoding
text, but it can be changed to any other program. If you are looking for a
base64 plugin, there might be better alternatives since this plugin is mainly
focused on running an external command for encoding and decoding.

# Features
## Decoding
Selected base64 encoded strings can be decoded. The output is shown in a new
buffer window.

## Encoding
It is possible to encode the text to base64 which was a result of the decoding.
The encoded text is saved to the default register (is "yanked").

# Dependencies
base64 tool executable is needed.

# Commands
Can be found under plugin/nvim-base64.lua

## Example usage with Lazy.nvim
```
return {
  url = "url-to-plugin-repository",
  keys = {
    { "<leader>D", "<Plug>(DecodeBase64)", mode = "v", desc = "Base64 decode selected" },
    { "<leader>E", "<Plug>(EncodeAsBase64)", mode = "n", desc = "Base64 encode contents of buffer" },
  },
}
```


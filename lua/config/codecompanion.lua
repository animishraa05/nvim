require("codecompanion").setup({
  adapters = {
    gemini = function()
      return require("codecompanion.adapters").extend("gemini", {
        env = {
          api_key = "GEMINI_API_KEY",
        },
      })
    end,
    -- You can also add Ollama here if you want to run local models for free
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        env = {
          url = "http://127.0.0.1:11434",
        },
        schema = {
          model = {
            default = "hf.co/prism-ml/Ternary-Bonsai-27B-gguf:Q2_0",
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama",
    },
    agent = {
      adapter = "ollama",
    },
  },
  display = {
    chat = {
      window = {
        layout = "vertical", -- Can be 'vertical', 'horizontal', 'float'
      },
    },
  },
})

local keymap = vim.keymap
keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle CodeCompanion Chat" })
keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "CodeCompanion Actions" })
keymap.set("v", "<leader>ce", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true, desc = "Add code to CodeCompanion Chat" })
keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true, desc = "Inline CodeCompanion prompt" })

-- Expand 'cc' into CodeCompanion in the command line
vim.cmd([[cab cc CodeCompanion]])

local utils = require("utils")

return {
  --- Autocompletion
  {
    "Saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "LuaSnip" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      completion = {
        -- accept = { auto_brackets = { enabled = false } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
          border = "rounded",
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            treesitter = { "lsp" },
            components = {
              kind_icon = {
                highlight = function(ctx) return "BlinkCmpKind" .. ctx.kind end,
              },
              source_name = {
                width = { max = 8 },
                text = function(ctx) return "[" .. ctx.source_name .. "]" end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
      },
      keymap = {
        preset = "enter",
        ["<C-j>"] = { "select_and_accept", "fallback" },
        ["<C-h>"] = { "show", "show_documentation", "hide_documentation" },
        -- ["<C-j>"] = { "select_and_accept", utils.plugins.blink_luasnip_expand() },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "snippets", "buffer", "lsp", "path", "lazydev" },
        min_keyword_length = function(ctx)
          if ctx.trigger.kind == "trigger_character" then
            return 0
          elseif ctx.trigger.kind == "manual" then
            return 0
          else
            return 3
          end
        end,
        providers = {
          lazydev = {
            name = "nvim",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      cmdline = {
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(ctx) return vim.fn.getcmdtype() == ":" end,
          },
          ghost_text = { enabled = true },
        },
        enabled = true,
        keymap = { preset = "cmdline" },
      },
    },
  },
  --- Dependencies (used by other plugins)
  { "nvim-lua/plenary.nvim" }, -- Required by: telescope, neotest, harpoon
  --- Formatter
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "FormatEnable", "FormatDisable" },
    -- stylua: ignore
    keys = {
      { "<F3>", function() require("conform").format({ async = false, lsp_fallback = true }) end, mode = { "n", "v" }, desc = "Conform: Format buffer" },
      { "<leader>tf", utils.plugins.conform_toggle, desc = "Conform: Enable/Disable autoformat-on-save." },
      { "<leader>tF", utils.plugins.conform_toggle_local, desc = "Conform: Enable/Disable autoformat-on-save for the current buffer." },
    },
    opts = {
      log_level = vim.log.levels.OFF, -- default: ERROR
      formatters_by_ft = {
        ["*"] = { "trim_whitespace" },
        bash = { "shfmt" },
        css = { "prettier" },
        html = { "prettier" },
        htmldjango = { "djlint" },
        javascript = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier_markdown", "markdown-toc" },
        php = { "php_cs_fixer" },
        python = { "isort", "docformatter", "black" },
        sh = { "shfmt" },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = function(bufnr)
        -- Only apply format if `disable_autoformat` is not true
        if not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat) then
          return { timeout_ms = 1000, lsp_fallback = true }
        end
      end,
      formatters = {
        black = {
          command = "uv",
          prepend_args = { "run", "black", "--line-length", "88" },
        },
        isort = {
          command = "uv",
          prepend_args = { "run", "isort" },
        },
        docformatter = {
          command = "uv",
          args = { "run", "docformatter", "-" },
          stdin = true,
        },
        djlint = { prepend_args = { "--indent", "2" } },
        prettier = { prepend_args = { "--tab-width", "2" } },
        shfmt = { prepend_args = { "-i", "4" } },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        }, -- overwrites stylua.toml
      },
    },
    init = function() vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]] end,
    config = function(_, opts)
      require("conform").setup(opts)

      -- Add custom options for markdown prettier
      local markdown_formatter = vim.deepcopy(require("conform.formatters.prettier"))
      require("conform.util").add_formatter_args(markdown_formatter, {
        "--prose-wrap",
        "always",
        "--print-width",
        "80",
      }, { append = false })
      ---@cast markdown_formatter conform.FormatterConfigOverride
      require("conform").formatters.prettier_markdown = markdown_formatter
    end,
  },
  --- Language Server Protocol
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    event = { "BufReadPre", "BufWritePost", "BufNewFile" },
    opts = {
      keys = function(ev)
        for _, k in pairs({
          { "gD", vim.lsp.buf.declaration, "Go to declaration" },
          { "gd", utils.config.lsp_centered_definition(), "Go to definition" },
          { "gi", vim.lsp.buf.implementation, "Go to implementation" },
          { "go", vim.lsp.buf.type_definition, "Go to type definition (origin)" },
          { "gr", vim.lsp.buf.references, "View references" },
          { "<F1>", vim.diagnostic.open_float, "Open float diagnostic info" },
          { "<F2>", vim.lsp.buf.rename, "Rename object" },
          -- <F3> (format current buffer) is handled by Conform
          { "<F4>", vim.lsp.buf.code_action, "Code action" },
          { "<leader>gq", vim.diagnostic.setloclist, "Set loclist" },
          { "<leader>tD", utils.config.lsp_toggle_diagnostics(), "Toggle diagnostics" },
        }) do
          vim.keymap.set("n", k[1], k[2], { buffer = ev.buf, desc = "LSP: " .. k[3] })
        end
      end,
    },
    config = function(_, opts)
      -- Only attach keys if there is a working server
      vim.api.nvim_create_autocmd("LspAttach", {
        group = utils.autocmd.group_id,
        desc = "LSP: Attach actions to the current buffer",
        callback = opts.keys,
      })

      -- Add cmp capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if package.loaded["blink.cmp"] then
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      end

      -- Disable logs
      vim.lsp.log.set_level(vim.lsp.log_levels.OFF)

      -- Apply server configurations
      require("mason-lspconfig").setup({
        automatic_enable = { exclude = { "jdtls" } },
      })
    end,
  },
  --- Mason package manager for non-nvim tools
  {
    "mason-org/mason.nvim",
    build = { ":MasonUpdate" },
    cmd = "Mason",
    keys = {
      { "<leader>cM", "<Cmd>Mason<CR>", desc = "Mason: Open panel" },
    },
    opts = {
      ensure_installed = {
        "bash-language-server", -- Bash language server
        "lua-language-server", -- Lua language server
        "marksman", -- Markdown language server
        "markdown-toc", -- Markdown TOC generator (under tag: `<!-- toc -->`)
        "prettier", -- Formatter for css, html, json, javascript, yaml and more.
        "python-lsp-server", -- Fork of python-language-server
        "shfmt", -- Bash/sh formatter
        "stylua", -- Lua formatter
        "texlab", -- LaTeX language server
        "vtsls", -- TypeScript language server
      },
      log_level = vim.log.levels.OFF, -- default: INFO
      ui = { border = "rounded" },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      utils.plugins.mason_install_pylsp_rope()
      -- trigger FileType event to try loading newly installed servers
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(
          function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buf = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  --- Snippets
  {
    "L3MON4D3/LuaSnip",
    opts = {
      enable_autosnippets = false,
      -- Don't jump into snippets that have been left
      delete_check_events = "TextChanged,InsertLeave",
      region_check_events = "CursorMoved",
    },
    config = function(_, opts)
      local ls = require("luasnip")

      -- Add custom snippets
      local custom_snips = NeovimPath .. "/lua/snippets/"
      require("luasnip.loaders.from_lua").load({ paths = { custom_snips } })

      -- Add virtual marks on inputs
      local types = require("luasnip.util.types")
      opts.ext_opts = {
        [types.choiceNode] = {
          active = { virt_text = { { "← Choice", "Conceal" } } },
          pasive = { virt_text = { { "← Choice", "Comment" } } },
        },
        [types.insertNode] = {
          active = { virt_text = { { "← Insert", "Conceal" } } },
          pasive = { virt_text = { { "← Insert", "Comment" } } },
        },
      }
      ls.setup(opts)
      ls.log.set_loglevel("error") -- :h luasnip-logging
    end,
    keys = {
      {
        "<C-j>",
        function()
          if require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Expand snippet or jump to the next input index.",
        silent = true,
      },
      {
        "<C-f>",
        function()
          if require("luasnip").jumpable(1) then
            require("luasnip").jump(1)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Jump to the next input index.",
        silent = true,
      },
      {
        "<C-k>",
        function()
          if require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Jump to the previous input index.",
        silent = true,
      },
      {
        "<C-l>",
        function()
          if require("luasnip").choice_active() then
            return "<Plug>luasnip-next-choice"
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Cycle to the next choice in the snippet.",
        silent = true,
        expr = true,
      },
      {
        "<C-h>",
        function()
          if require("luasnip").choice_active() then
            return "<Plug>luasnip-prev-choice"
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip: Cycle to the previous choice in the snippet.",
        silent = true,
        expr = true,
      },
    },
  },
  --- Telescope: Searches with fzf
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    -- branch = "0.1.x",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        init = function()
          utils.autocmd.on_load(
            "telescope.nvim",
            function() require("telescope").load_extension("fzf") end
          )
        end,
      },
      {
        "polirritmico/telescope-lazy-plugins.nvim",
        dev = false and not DisableMyPlugins,
        init = function()
          utils.autocmd.on_load(
            "telescope.nvim",
            function() require("telescope").load_extension("lazy_plugins") end
          )
        end,
      },
    },
    -- stylua: ignore
    keys = {
      -- Builtins
      { "<leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope: Find files (nvim runtime path)" },
      { "<leader>fF", "<Cmd>Telescope find_files cwd=%:p:h hidden=true prompt_title=Find\\ Files\\ (cwd\\ from\\ file)<CR>", desc = "Telescope: Find files (from file path)" },
      { "<leader>fb", "<Cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", desc = "Telescope: Find/Switch between buffers" },
      { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope: Find grep" },
      { "<leader>fG", "<Cmd>Telescope live_grep cwd=%:p:h prompt_title=Live\\ Grep\\ (cwd\\ from\\ file)<CR>", desc = "Telescope: Find grep (from buffer path)" },
      { "<leader>fg", "<Cmd>Telescope grep_string<CR>", mode = "x", desc = "Telescope: Find Grep (selected string)" },
      { "<leader>fr", "<Cmd>Telescope registers<CR>", mode = { "n", "v" }, desc = "Telescope: Select and paste from registers" },
      { "<leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "Telescope: Find recent/old files" },
      { "<leader>fl", "<Cmd>Telescope resume<CR>", desc = "Telescope: List results of the last telescope search" },
      { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope: Find in help tags" },
      { "<leader>fm", "<Cmd>Telescope marks<CR>", desc = "Telescope: Find buffer marks" },
      { "<leader>fT", "<Cmd>Telescope<CR>", desc = "Telescope: Find telescope builtins functions" },
      { "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Telescope: Find symbols" },
      { "<leader>fs", utils.plugins.telescope_lsp_search_symbols_fallback, desc = "Telescope: Find symbols" },
      { "<leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Telescope: Find workspace symbols" },
      { "<leader>fw", "<Cmd>Telescope current_buffer_fuzzy_find<CR>",desc = "Telescope: Find word (like `/`)" },
      { "zf", utils.plugins.telescope_spell_suggest, desc = "Telescope: Find spell word suggestion" },

      -- Configs
      { "<leader>cs", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath."/lua/snippets/"<CR>]], desc = "Telescope: Snippets sources" },
      { "<leader>cf", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath."/after/ftplugin/"<CR>]], desc = "Telescope: Filetypes configurations" },
      { "<leader>cc", [[<Cmd>execute "Telescope find_files cwd=".NeovimPath<CR>]], desc = "Telescope: Plugins configurations" },
      { "<leader>cu", [[<Cmd>execute "Telescope live_grep cwd=".NeovimPath."/lua/utils/ prompt_title=Find\\ Utils"<CR>]], desc = "Telescope: Utils" },
      { "<leader>cp", "<Cmd>Telescope lazy_plugins<CR>", desc = "Telescope: Config plugins" },

      -- Custom
      { "<leader>fn", utils.custom.scratchs, desc = "Telescope: Open or create a new scratch buffer" },
    },
    opts = function()
      local layout_strategy, layout_config
      if Workstation then
        layout_strategy = "flex"
        layout_config = {
          flex = { flip_columns = 120 },
          horizontal = { preview_width = { 0.6, max = 100, min = 30 } },
        }
      else
        layout_strategy = "vertical"
        layout_config = { vertical = { preview_cutoff = 20, preview_height = 9 } }
      end

      -- stylua: ignore
      local file_ignore_patterns = {
        "venv", "__pycache__", "%.doc", "%.docx", "%.epub", "%.exe", "%.ico",
        "%.jar", "%.jpg", "%.m4a", "%.mkv", "%.mp3", "%.mp4", "%.mus", "%.o",
        "%.odt", "%.ogg", "%.out", "%.pdb", "%.pdf", "%.png", "%.so", "%.suo",
        "%.ttf", "%.webm", "%.webp", "%.xlsx", "%.zip",
      }
      for i = 1, #file_ignore_patterns do
        table.insert(file_ignore_patterns, file_ignore_patterns[i]:upper())
      end

      return {
        defaults = {
          file_ignore_patterns = file_ignore_patterns,
          layout_strategy = layout_strategy,
          layout_config = layout_config,
          path_display = { "truncate" },
          prompt_prefix = "   ",
          selection_caret = "󰄾 ",
          sorting_strategy = "ascending",
          mappings = {
            ["i"] = {
              ["<CR>"] = utils.plugins.telescope_open_single_or_multi,
              ["<C-q>"] = utils.plugins.telescope_open_and_fill_qflist,
              ["<C-f>"] = utils.plugins.telescope_narrow_matches,
              ["<C-h>"] = "which_key", -- show/hide keymaps help
              ["<ESC>"] = "close",
              ["<LeftMouse>"] = function() end,
            },
          },
        },
        pickers = {
          buffers = { mappings = { ["i"] = { ["<C-c>"] = "delete_buffer" } } },
          find_files = { follow = true },
          live_grep = { additional_args = { "--follow" } },
          grep_string = { additional_args = { "--follow" } },
        },
        extensions = {
          ---@module "telescope._extensions.lazy_plugins"
          ---@type TelescopeLazyPluginsUserConfig
          lazy_plugins = {
            -- stylua: ignore
            custom_entries = {
              { name = "Core", filepath = NeovimPath .. "/lua/plugins/core.lua" },
              { name = "Develop", filepath = NeovimPath .. "/lua/plugins/develop.lua" },
              { name = "Extras", filepath = NeovimPath .. "/lua/plugins/extras/spec.lua" },
              { name = "Helpers", filepath = NeovimPath .. "/lua/plugins/helpers.lua" },
              { name = "UI", filepath = NeovimPath .. "/lua/plugins/ui.lua" },
            },
          },
        },
      }
    end,
  },
  --- Treesitter: Parse program langs for highlights, indent, conceals, etc.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSLog", "TSInstall", "TSUninstall" },
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "csv" },
      },
      indent = {
        enable = true,
        disable = { "python" }, -- Awfull experience
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },
      -- full list in plugins/extras/treesitter
      ensure_installed = {
        "bash",
        "comment",
        "gitcommit",
        "lua",
        "markdown",
        "python",
        "regex",
        "vim",
        "vimdoc",
      },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup(opts)
      utils.plugins.treesitter_ensure_installed(opts.ensure_installed, ts)

      vim.api.nvim_create_autocmd("FileType", {
        group = utils.autocmd.group_id,
        desc = "Autoenable Tree-sitter functionality",
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if lang == nil then
            return
          end
          -- Highlight & Indent. (Folds are set in lua/config/settings.lua)
          pcall(vim.treesitter.start, ev.buf)
          if lang ~= "python" then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

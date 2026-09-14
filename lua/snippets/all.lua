--- Snippets For All Typefiles
return {
  s(
    {
      trig = "datecurrent",
      name = "Current date",
      dscr = "Insert the current date in various formats",
    },
    c(1, {
      p(os.date, "%Y-%m-%d"),
      p(os.date, "%d-%m-%Y"),
      p(os.date, "%H:%M"),
      p(os.date, "%Y-%m-%d %H:%M"),
      p(os.date, "%Y-%m-%d %H:%M -0300"),
      p(os.date, "%d-%m-%Y %H:%M"),
    })
  ),

  s("shebang", t({ "#!/usr/bin/env bash", "", "" })),

  s({
    trig = "---",
    name = "Horizontal separator line",
    dscr = "A horizontal separation line (79 characters).",
  }, {
    f(function()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local width = vim.api.nvim_get_option_value("textwidth", {}) - col - 1
      return string.rep("-", width)
    end),
    t({ "" }),
  }),

  s(
    {
      trig = "header",
      name = "Framed header",
      dscr = "A framed header that wraps around the content.",
    },
    fmt(
      [[
      {}{}
      {} {}
      {}{}

      {}]],
      {
        f(function() return vim.bo.commentstring:match("^(.-)%s*%%s") or "" end),
        f(function()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local width = vim.api.nvim_get_option_value("textwidth", {}) - col - 1
          return string.rep("-", width)
        end),
        f(function() return vim.bo.commentstring:match("^(.-)%s*%%s") or "" end),
        i(1),
        f(function() return vim.bo.commentstring:match("^(.-)%s*%%s") or "" end),
        f(function()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local width = vim.api.nvim_get_option_value("textwidth", {}) - col - 1
          return string.rep("-", width)
        end),
        i(0),
      }
    )
  ),

  s(
    {
      trig = "license",
      name = "License Layout",
      dscr = "Template with various licenses.",
    },
    fmt(
      [[
            # Copyright (C) {} {}
            #
            # This program is part of {} and is released under
            # the {}


            ]],
      {
        f(function() return os.date("%Y") end),
        i(1, "Name (email)"),
        i(2, "Project-Name"),
        c(3, {
          t("GPLv2 License: https://www.gnu.org/licenses/old-licenses/gpl-2.0.html"),
          t("GPLv3 License: https://www.gnu.org/licenses/gpl-3.0.html"),
          t("Apache-2.0 License: https://www.apache.org/licenses/LICENSE-2.0"),
          t("MIT License: https://mit-license.org/"),
          i(1),
        }),
      }
    )
  ),

  s(
    {
      trig = "box",
      name = "Text box",
      dscr = "A box margin.",
    },
    fmt(
      [[
        ╭─{}─╮
        │ {} │
        ╰─{}─╯

        {}]],
      {
        f(function(args) return string.rep("─", string.len(args[1][1])) end, { 1 }),
        i(1),
        f(function(args) return string.rep("─", string.len(args[1][1])) end, { 1 }),
        i(0),
      }
    )
  ),
}

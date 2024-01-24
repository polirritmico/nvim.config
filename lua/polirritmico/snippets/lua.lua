-- Lua Snippets
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Avoid multiple versions of the same snippet on reload
local reload_key = { key = "my_lua_snippets" }

ls.add_snippets("lua", {
  s(
    {
      trig = "require",
      name = "Require snippet",
      dscr = "Set the variable name to the last require.",
    },
    fmt(
      [[
        local {} = require("{}"){}]],
      {
        f(function(import_name)
          -- local parts = vim.split(import_name[1][1], ".", true)
          local parts = vim.split(import_name[1][1], ".", { plain = true })
          return parts[#parts] or ""
        end, { 1 }),
        i(1),
        i(0),
      }
    )
  ),

  s(
    { trig = "snippet", dscr = "Meta-snippet to make snippets." },
    fmt("{}", {
      c(1, {
        fmt(
          [=[
                s("{}", fmt({}, {{{}}})),]=],
          {
            i(1),
            i(2, '"snippet"'),
            i(3),
          }
        ),
        fmt(
          [=[
                s(
                    {{trig = "{}", name = "{}", dscr = "{}"}}, fmt([[
                    {}
                    ]], {{
                    {}
                }})),]=],
          {
            i(1),
            i(2, "Name"),
            i(3, "Description"),
            i(4),
            i(5),
          }
        ),
      }),
    })
  ),

  s(
    {
      trig = "mapping",
      name = "Add keymap",
      dscr = "Layout for adding custom keymaps to Neovim.",
    },
    fmta(
      [[
	    vim.keymap.set(<mode>, "<key>", <command>, {<options>})
        ]],
      {
        mode = c(1, {
          t('{"n"}'),
          t('{"n", "v"}'),
          t('{"v"}'),
          t('{"i"}'),
          fmt('"{}"', i(1)),
        }),
        key = c(2, { fmt("<leader>{}", i(1)), i(1) }),
        command = c(
          3,
          { fmt([["<Cmd>{}<CR>"]], i(1, "command")), i(1, "vim.command") }
        ),
        options = t("silent = true"),
      }
    )
  ),

  s(
    {
      trig = "lazymap",
      name = "Lazy keymap",
      dscr = "Layout for adding custom keymaps using the Lazy key spec.",
    },
    fmta([[{ "<lhs>", <rhs><mode><ft>, desc = "<desc>" },]], {
      lhs = c(1, {
        sn(1, { t("<leader>"), r(1, "user_lhs") }),
        sn(1, { r(1, "user_lhs") }),
      }),
      rhs = c(2, {
        { t('"'), r(1, "user_rhs"), t('"') },
        { t("function() "), r(1, "user_rhs"), t(" end") },
      }),
      mode = c(3, {
        t(', mode = { "n", "v" }'),
        t(""),
      }),
      ft = c(4, {
        { t(', ft = "'), r(1, "user_ft"), t('"') },
        t(""),
      }),
      desc = i(5, "Plugin_Name: Description."),
    }),
    {
      stored = {
        ["user_lhs"] = i(1, "lhs"),
        ["user_rhs"] = i(1, "rhs"),
        ["user_ft"] = i(1, "filetype"),
      },
    }
  ),

  s(
    {
      trig = "---",
      name = "Horizontal line",
      dscr = "A horizontal separation line (79 characters).",
    },
    t("-------------------------------------------------------------------------------")
  ),
}, reload_key)

-- extend for htmldjango
require("luasnip").filetype_extend("htmldjango", { "html" })

--- HTML Snippets
return {
  -- Templates
  s(
    { trig = "layouthtml", name = "HTML layout", dscr = "HTML layout with Bootstrap" },
    fmt(
      [[
        <!doctype html>
        <html lang="es">
          <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Título del sitio</title>
            <link
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
              rel="stylesheet"
              integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
              crossorigin="anonymous"
            />
            <link
              rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
            />
            <link rel="stylesheet" href="style.css" />
          </head>
          <body>
            <h1>¡Hola mundo!</h1>
          </body>
          <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
            crossorigin="anonymous"
          ></script>
        </html>
        ]],
      {}
    )
  ),
  -- Headers
  s(
    {
      trig = [[%.h(.+)]],
      trigEngine = "pattern",
      name = "Tag Header",
      desc = "Usage: .h`<header level>`",
    },
    fmt([[<h{}{}>{}</h{}>]], {
      f(function(_, sn) return sn.captures[1] ~= "(.+)" and sn.captures[1] or "" end),
      c(1, { fmt([[ class="{}"]], { i(1, "name") }, { dedent = false }), t("") }),
      i(0, "Title"),
      f(function(_, sn) return sn.captures[1] ~= "(.+)" and sn.captures[1] or "" end),
    })
  ),

  s(
    { trig = ".p", name = "Paragraph", dscr = "Add a paragraph tag." },
    fmt([[{}{}</p>]], {
      c(1, { fmt([[<p class="{}">]], i(1, "name")), t("<p>") }),
      i(2),
    })
  ),

  s(
    { trig = ".div", name = "Div label", dscr = "Add a div tag." },
    fmt([[{}{}</div>]], {
      c(1, { fmt([[<div class="{}">]], i(1, "name")), t("<div>") }),
      i(2),
    })
  ),

  s(
    { trig = ".span", name = "Span label", dscr = "Add a span tag." },
    fmt([[{}{}</span>]], {
      c(1, { fmt([[<span class="{}">]], i(1, "name")), t("<span>") }),
      i(2),
    })
  ),

  s(
    { trig = ".nav", name = "Navbar", dscr = "Add a nav tag." },
    fmt([[{}{}</nav>]], {
      c(1, { fmt([[<nav class="{}">]], i(1, "name")), t("<nav>") }),
      i(2),
    })
  ),

  s(
    { trig = ".script", name = "Script", dscr = "Add a script tag." },
    fmt([[<script src="{}"></script>]], {
      i(1, "script.js"),
    })
  ),

  -- Text formatting
  s(".b", fmt("<b>{}</b>", i(1))),

  s(".strong", fmt("<strong>{}</strong>", i(1))),

  s(".i", fmt("<i>{}</i>", i(1))),

  s(".em", fmt("<em>{}</em>", i(1))),

  s(".mark", fmt("<mark>{}</mark>", i(1))),

  s(".small", fmt("<small>{}</small>", i(1))),

  s(".del", fmt("<del>{}</del>", i(1))),

  s(".ins", fmt("<ins>{}</ins>", i(1))),

  s(".sub", fmt("<sub>{}</sub>", i(1))),

  s(".sup", fmt("<sup>{}</sup>", i(1))),

  -- Lists
  s(
    { trig = ".ul", name = "Unordered List", dscr = "Add unordered list tag" },
    fmt(
      [[
        {}
            {}
        </ul>
        ]],
      {
        c(1, { t("<ul>"), fmt([[<ul class="{}">]], i(1, "classname")) }),
        i(2, "li"),
      }
    )
  ),

  s(".li", fmt([[<li>{}</li>]], { i(1) })),

  -- urls
  s(
    { trig = ".a", name = "urls", dscr = "Add url links" },
    fmt(
      [[
        <a href="{}">{}</a>
        ]],
      {
        i(1, "http://"),
        i(2, "text"),
      }
    )
  ),

  -- Django
  s(
    { trig = "djm", name = "Base tag", dscr = "Django base template mark" },
    fmta(
      [[
        {% <> %}
        ]],
      {
        i(1, "command"),
      }
    )
  ),

  s(
    { trig = "djext", name = "Template tag", dscr = "Django extend template mark" },
    fmta(
      [[
        {% extends "<>.html" %}
        ]],
      {
        i(1, "base"),
      }
    )
  ),

  s(
    { trig = "djblk", name = "Block content tag", dscr = "Django block content" },
    fmta(
      [[
        {% block content %}
        <>
        {% endblock content %}
        ]],
      {
        i(1),
      }
    )
  ),

  s(
    { trig = "djfor", name = "For tag", dscr = "Django for black content" },
    fmta(
      [[
        {% for <> in <> %}
            <>
        {% endfor %}
        ]],
      {
        i(1, "element"),
        i(2, "model"),
        i(3),
      }
    )
  ),
}

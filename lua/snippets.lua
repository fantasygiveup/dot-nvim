local vars = require("vars")
local ls = require("luasnip")
local s = ls.snippet
local p = require("luasnip.extras").partial
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("all", {
  s("loremSent", {
    t(
      "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat."
    ),
  }),
  s("loremPara", {
    t(
      "Lorem ipsum dolor sit amet, officia excepteur ex fugiat reprehenderit enim labore culpa sint ad nisi Lorem pariatur mollit ex esse exercitation amet. Nisi anim cupidatat excepteur officia. Reprehenderit nostrud nostrud ipsum Lorem est aliquip amet voluptate voluptate dolor minim nulla est proident. Nostrud officia pariatur ut officia. Sit irure elit esse ea nulla sunt ex occaecat reprehenderit commodo officia dolor Lorem duis laboris cupidatat officia voluptate. Culpa proident adipisicing id nulla nisi laboris ex in Lorem sunt duis officia eiusmod. Aliqua reprehenderit commodo ex non excepteur duis sunt velit enim. Voluptate laboris sint cupidatat ullamco ut ea consectetur et est culpa et culpa duis."
    ),
  }),
  s(
    "mitl",
    fmt(
      [[
The MIT License (MIT)

Copyright (c) {} {}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
    ]],
      { vars.user_name, os.date("%Y") }
    )
  ),
  s("now", fmt("{}", { os.date("%Y-%m-%d %a %H:%M") })), -- eg. 2024-08-01 Thu 18:56
  s("vimopt", fmt("vim: set {}={}:", { i(1), i(0) })), -- set file option
})

ls.add_snippets("go", {
  s("pre", fmt([[fmt.Fprintf(os.Stderr, "{}\n")]], { i(0) })),
  s("pro", fmt([[fmt.Println("{}")]], { i(0) })),
})

ls.add_snippets("lua", {
  s(
    "fn",
    fmt(
      [[
function {}({})
  {}
end
  ]],
      { i(1), i(2), i(0) }
    )
  ),
})

ls.add_snippets("lua", {
  s(
    "fnl",
    fmt(
      [[
local function {}({})
  {}
end
  ]],
      { i(1), i(2), i(0) }
    )
  ),
})

ls.add_snippets("cpp", {
  s(
    "csmain",
    fmt(
      [[
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
typedef vector<int> vi;
typedef pair<int,int> pi;

#define F first
#define S second
#define PB push_back
#define MP make_pair
#define REP(i,a,b) for (int i = a; i <= b; i++)
#define SQ(a) a*a

int main() {{
    ios::sync_with_stdio(0);
    cin.tie(0);

    // Solution comes here.
    {}
}}
  ]],
      { i(0) }
    )
  ),
  s(
    "csleet",
    fmt(
      [[
#include <bits/stdc++.h>

using namespace std;

class Solution {{
public:
    {}
}};

int main() {{
    auto sol = Solution{{}};
    // cout << sol.your_method() << endl;
}}
  ]],
      { i(0) }
    )
  ),
  s(
    "csio",
    fmt(
      [[
freopen("input.txt", "r", stdin);
freopen("output.txt", "w", stdout);
{}
  ]],
      { i(0) }
    )
  ),
})

ls.add_snippets("markdown", {
  s(
    "header",
    fmt(
      [[
---
title: {}
author: Illia Danko
created: {}
tags: [draft{}]
---

{}
  ]],
      { i(1), p(os.date, "%Y-%m-%d"), i(2), i(0) }
    )
  ),
})

ls.add_snippets("elixir", {
  s(
    "credo",
    fmt(
      [[
      {{:credo, "~> 1.7", only: [:dev, :test], runtime: false}}{}
  ]],
      { i(0) }
    )
  ),
})

html_templs = {
  s(
    "html5",
    fmt(
      [[
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{}</title>
  </head>

  <body>
    {}
  </body>
</html>
    ]],
      { i(1), i(0) }
    )
  ),
}

ls.add_snippets("html", html_templs)

elixir_templs = {
  s("%=", fmt([[<%= {} %>]], { i(0) })),
  s("%%", fmt([[<% {} %>]], { i(0) })),
  s("%end", fmt([[<% end %>]], {})),
  s(
    "%for",
    fmt(
      [[
  <%= for {} <- {} do %>
    {}
  <% end %>
  ]],
      { i(1), i(2), i(0) }
    )
  ),
}

ls.add_snippets("heex", elixir_templs)
ls.add_snippets("elixir", elixir_templs)

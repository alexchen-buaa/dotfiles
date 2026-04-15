local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local M = {
  regular = {},
  auto = {},
}

-- Context predicates.
local function in_math()
  return vim.fn.exists("*vimtex#syntax#in_mathzone") == 1
    and vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local function in_text()
  return not in_math()
end

local function blank_line()
  return vim.api.nvim_get_current_line():match("^%s*$") ~= nil
end

local function display_math()
  return in_math() and blank_line()
end

local function inline_math()
  return in_math() and not blank_line()
end

-- Small helpers for building snippets.
local function extend(base, extra)
  return vim.tbl_extend("force", {}, base or {}, extra or {})
end

local function ctx(kind, trig, opts)
  opts = opts or {}
  return {
    trig = trig,
    regTrig = opts.regTrig,
    wordTrig = opts.wordTrig ~= false,
    priority = opts.priority,
    condition = opts.condition,
    snippetType = kind == "auto" and "autosnippet" or nil,
  }
end

local function add(kind, snippet)
  table.insert(M[kind], snippet)
end

local function add_text(kind, trig, body, opts)
  add(kind, s(ctx(kind, trig, opts), t(body)))
end

local function add_fmt(kind, trig, template, nodes, opts)
  add(kind, s(ctx(kind, trig, opts), fmta(template, nodes)))
end

local function add_regex(kind, trig, nodes, opts)
  add(kind, s(ctx(kind, trig, extend({ regTrig = true, wordTrig = false }, opts)), nodes))
end

local function add_regex_fmt(kind, trig, template, nodes, opts)
  add_regex(kind, trig, fmta(template, nodes), opts)
end

local function add_regex_text(kind, trig, builder, opts)
  add_regex(kind, trig, f(function(_, snip)
    return builder(snip.captures)
  end), opts)
end

local function cap(index)
  return f(function(_, snip)
    return snip.captures[index]
  end)
end

local function merge_nodes(...)
  local merged = {}

  for _, chunk in ipairs({ ... }) do
    for _, node in ipairs(chunk) do
      merged[#merged + 1] = node
    end
  end

  return merged
end

local function add_items(kind, items, base_opts)
  for _, item in ipairs(items) do
    local opts = extend(base_opts)

    if item.condition ~= nil then
      opts.condition = item.condition
    end
    if item.wordTrig ~= nil then
      opts.wordTrig = item.wordTrig
    end
    if item.priority ~= nil then
      opts.priority = item.priority
    end
    if item.regTrig ~= nil then
      opts.regTrig = item.regTrig
    end

    add_text(kind, item.trig, item.body, opts)
  end
end

local function add_backslash_commands(names)
  for _, name in ipairs(names) do
    add_regex_text("auto", "([^\\])(" .. name .. ")", function(captures)
      return captures[1] .. "\\" .. captures[2]
    end, { condition = in_math })
  end
end

local function add_spaced_commands(names, next_pattern)
  for _, name in ipairs(names) do
    add_regex_fmt("auto", "\\(" .. name .. ")(" .. next_pattern .. ")", "\\<> <>", {
      cap(1),
      cap(2),
    }, { condition = in_math })
  end
end

local function add_letter_boundary(pattern, template, nodes_fn, opts)
  local settings = extend({ condition = in_math }, opts)

  add_regex_fmt("auto", "([^%a\\])([A-Za-z])" .. pattern, "<>" .. template, merge_nodes({
    cap(1),
  }, nodes_fn(cap(2))), settings)

  add_regex_fmt("auto", "^([A-Za-z])" .. pattern, template, nodes_fn(cap(1)), settings)
end

local function add_wrapper_subscripts(wrappers)
  for _, wrapper in ipairs(wrappers) do
    add_regex_fmt("auto", "\\" .. wrapper .. "{([A-Za-z])}(%d)", "\\" .. wrapper .. "{<>}_{<>}", {
      cap(1),
      cap(2),
    }, { condition = in_math })
  end
end

local function add_chain_rewrites(items)
  for _, item in ipairs(items) do
    add_text("auto", item.trig, item.body, {
      regTrig = true,
      wordTrig = false,
      condition = in_math,
      priority = item.priority,
    })
  end
end

local function add_greek_suffix(name, suffixes, template, nodes_fn, opts)
  local settings = extend({ condition = in_math }, opts)

  for _, suffix in ipairs(suffixes) do
    add_regex_fmt("auto", "\\(" .. name .. ")" .. suffix, template, nodes_fn(cap(1)), settings)
  end
end

local greek = {
  "alpha",
  "beta",
  "eta",
  "gamma",
  "Gamma",
  "delta",
  "Delta",
  "zeta",
  "theta",
  "Theta",
  "vartheta",
  "iota",
  "kappa",
  "lambda",
  "Lambda",
  "mu",
  "nu",
  "xi",
  "Xi",
  "pi",
  "Pi",
  "rho",
  "sigma",
  "Sigma",
  "tau",
  "phi",
  "Phi",
  "varphi",
  "psi",
  "Psi",
  "chi",
  "omega",
  "Omega",
}

local trig_functions = {
  "arcsin",
  "sin",
  "arccos",
  "cos",
  "arctan",
  "tan",
  "csc",
  "sec",
  "cot",
}

local hyperbolic_functions = {
  "sinh",
  "cosh",
  "tanh",
  "coth",
}

local letter_modifiers = {
  { trig = "hat", body = "\\hat{<>}" },
  { trig = "bar", body = "\\bar{<>}" },
  { trig = "dot", body = "\\dot{<>}", priority = -1 },
  { trig = "ddot", body = "\\ddot{<>}", priority = 1 },
  { trig = "tilde", body = "\\tilde{<>}" },
  { trig = "und", body = "\\underline{<>}" },
  { trig = "vec", body = "\\vec{<>}" },
}

local greek_modifiers = {
  { trig = "hat", body = "\\hat{\\<>}" },
  { trig = "dot", body = "\\dot{\\<>}", priority = 1999 },
  { trig = "ddot", body = "\\ddot{\\<>}", priority = 2001 },
  { trig = "bar", body = "\\bar{\\<>}" },
  { trig = "vec", body = "\\vec{\\<>}" },
  { trig = "tilde", body = "\\tilde{\\<>}" },
  { trig = "und", body = "\\underline{\\<>}" },
}

local static_math = {
  { trig = "ome", body = "\\omega" },
  { trig = "Ome", body = "\\Omega" },
  { trig = "eps", body = "\\epsilon" },
  { trig = "vareps", body = "\\varepsilon" },
  { trig = "conj", body = "^{*}" },
  { trig = "Re", body = "\\mathrm{Re}" },
  { trig = "Im", body = "\\mathrm{Im}" },
  { trig = "top", body = "\\top" },
  { trig = "trace", body = "\\mathrm{Tr}" },
  { trig = "cb", body = "^{3}" },
  { trig = "invs", body = "^{-1}" },
  { trig = "xnn", body = "x_{n}" },
  { trig = "xii", body = "x_{i}" },
  { trig = "xjj", body = "x_{j}" },
  { trig = "xp1", body = "x_{n+1}" },
  { trig = "ynn", body = "y_{n}" },
  { trig = "yii", body = "y_{i}" },
  { trig = "yjj", body = "y_{j}" },
  { trig = "snn", body = "s_{n}" },
  { trig = "sp1", body = "s_{n+1}" },
  { trig = "ooo", body = "\\infty" },
  { trig = "sum", body = "\\sum" },
  { trig = "prod", body = "\\prod" },
  { trig = "+-", body = "\\pm", wordTrig = false },
  { trig = "-+", body = "\\mp", wordTrig = false },
  { trig = "...", body = "\\dots", wordTrig = false },
  { trig = "nabl", body = "\\nabla" },
  { trig = "times", body = "\\times" },
  { trig = "xx", body = "\\times" },
  { trig = "**", body = "\\cdot", wordTrig = false },
  { trig = "para", body = "\\parallel" },
  { trig = "===", body = "\\equiv", wordTrig = false },
  { trig = "!=", body = "\\neq", wordTrig = false },
  { trig = ">=", body = "\\geq", wordTrig = false },
  { trig = "<=", body = "\\leq", wordTrig = false },
  { trig = "neq", body = "\\neq" },
  { trig = "geq", body = "\\geq" },
  { trig = "leq", body = "\\leq" },
  { trig = ">>", body = "\\gg", wordTrig = false },
  { trig = "<<", body = "\\ll", wordTrig = false },
  { trig = "simm", body = "\\sim" },
  { trig = "sim=", body = "\\simeq", wordTrig = false },
  { trig = "prop", body = "\\propto" },
  { trig = "<->", body = "\\leftrightarrow ", wordTrig = false },
  { trig = "->", body = "\\to", wordTrig = false },
  { trig = "!>", body = "\\mapsto", wordTrig = false },
  { trig = "=>", body = "\\implies", wordTrig = false },
  { trig = "=<", body = "\\impliedby", wordTrig = false },
  { trig = "and", body = "\\cap" },
  { trig = "orr", body = "\\cup" },
  { trig = "inn", body = "\\in" },
  { trig = "notin", body = "\\not\\in" },
  { trig = "\\\\\\", body = "\\setminus", wordTrig = false },
  { trig = "sub=", body = "\\subseteq", wordTrig = false },
  { trig = "sup=", body = "\\supseteq", wordTrig = false },
  { trig = "eset", body = "\\emptyset" },
  { trig = "exists", body = "\\exists" },
  { trig = "LL", body = "\\mathcal{L}" },
  { trig = "HH", body = "\\mathcal{H}" },
  { trig = "TT", body = "\\mathcal{T}" },
  { trig = "SS", body = "\\mathcal{S}" },
  { trig = "AA", body = "\\mathcal{A}" },
  { trig = "DD", body = "\\mathcal{D}" },
  { trig = "CC", body = "\\mathbb{C}" },
  { trig = "RR", body = "\\mathbb{R}" },
  { trig = "ZZ", body = "\\mathbb{Z}" },
  { trig = "NN", body = "\\mathbb{N}" },
  { trig = "EE", body = "\\mathbb{E}" },
  { trig = "PP", body = "\\mathbb{P}" },
  { trig = "arg", body = "\\arg" },
  { trig = "max", body = "\\max" },
  { trig = "min", body = "\\min" },
  { trig = "inf", body = "\\inf" },
  { trig = "sup", body = "\\sup" },
  { trig = "ddt", body = "\\frac{d}{dt} " },
  { trig = "oint", body = "\\oint" },
  { trig = "iint", body = "\\iint" },
  { trig = "iiint", body = "\\iiint" },
  { trig = "kbt", body = "k_{B}T" },
  { trig = "msun", body = "M_{\\odot}" },
  { trig = "dag", body = "^{\\dagger}" },
  { trig = "o+", body = "\\oplus ", wordTrig = false },
  { trig = "ox", body = "\\otimes " },
  { trig = "he4", body = "{}^{4}_{2}He " },
  { trig = "he3", body = "{}^{3}_{2}He " },
}

-- Document and environment scaffolding.
add_fmt("auto", "mk", "$<>$", { i(1) }, { condition = in_text })
add_fmt("auto", "dm", "\\[\n  <>\n\\]", { i(1) }, { condition = in_text })
add_fmt("auto", "eqn", "\\begin{equation}\n  <>\n\\end{equation}", { i(1) }, {
  condition = in_text,
})
add_fmt("regular", "beg", "\\begin{<>}\n<>\n\\end{<>}", {
  i(1),
  i(2),
  rep(1),
})

-- Core math literals and operators.
add_items("auto", static_math, { condition = in_math })

add_fmt("auto", "text", "\\text{<>}<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "\"", "\\text{<>}<>", { i(1), i(0) }, {
  condition = in_math,
  wordTrig = false,
})
add_fmt("auto", "rd", "^{<>}<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "_", "_{<>}<>", { i(1), i(0) }, {
  condition = in_math,
  wordTrig = false,
})
add_fmt("auto", "sts", "_\\text{<>}", { i(1) }, { condition = in_math })
add_fmt("auto", "sq", "\\sqrt{ <> }<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "//", "\\frac{<>}{<>}<>", { i(1), i(2), i(0) }, {
  condition = in_math,
  wordTrig = false,
})
add_fmt("auto", "ee", "e^{ <> }<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "bf", "\\mathbf{<>}", { i(1) }, { condition = in_math })
add_fmt("auto", "rm", "\\mathrm{<>}<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "hat", "\\hat{<>}<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "bar", "\\bar{<>}<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "dot", "\\dot{<>}<>", { i(1), i(0) }, {
  condition = in_math,
  priority = -1,
})
add_fmt("auto", "ddot", "\\ddot{<>}<>", { i(1), i(0) }, { condition = in_math })
add_text("auto", "cdot", "\\cdot", { condition = in_math })
add_text("auto", "ldot", "\\ldot", { condition = in_math })
add_fmt("auto", "tilde", "\\tilde{<>}<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "und", "\\underline{<>}<>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "vec", "\\vec{<>}<>", { i(1), i(0) }, { condition = in_math })

-- Letter-based postfix snippets.
add_regex_fmt("auto", "([A-Za-z])(%d)", "<>_{<>}", { cap(1), cap(2) }, {
  condition = in_math,
  priority = -1,
})
add_regex_fmt("auto", "([A-Za-z])_(%d%d)", "<>_{<>}", { cap(1), cap(2) }, {
  condition = in_math,
})

for _, item in ipairs({
  {
    pattern = "rd",
    template = "<>^{<>}<>",
    nodes = function(letter)
      return { letter, i(1), i(0) }
    end,
    priority = 10,
  },
  {
    pattern = "cb",
    template = "<>^{3}",
    nodes = function(letter)
      return { letter }
    end,
    priority = 10,
  },
  {
    pattern = "conj",
    template = "<>^{*}",
    nodes = function(letter)
      return { letter }
    end,
    priority = 10,
  },
}) do
  add_letter_boundary(item.pattern, item.template, item.nodes, { priority = item.priority })
end

add_backslash_commands({ "exp", "log", "ln", "det" })

for _, modifier in ipairs(letter_modifiers) do
  add_letter_boundary(modifier.trig, modifier.body, function(letter)
    return { letter }
  end, { priority = modifier.priority })
end

for _, pattern in ipairs({ ",%.", "%.," }) do
  add_letter_boundary(pattern, "\\mathbf{<>}", function(letter)
    return { letter }
  end)
end

add_wrapper_subscripts({ "hat", "vec", "mathbf" })

-- Compatibility rewrites for combined autosnippets.
add_fmt("regular", "\\sum", "\\sum_{<> = <>}^{<>} <>", {
  i(1, "i"),
  i(2, "1"),
  i(3, "N"),
  i(0),
}, {
  condition = in_math,
  wordTrig = false,
})

add_fmt("regular", "\\prod", "\\prod_{<> = <>}^{<>} <>", {
  i(1, "i"),
  i(2, "1"),
  i(3, "N"),
  i(0),
}, {
  condition = in_math,
  wordTrig = false,
})

add_fmt("auto", "lim", "\\lim_{ <> \\to <> } <>", {
  i(1, "n"),
  i(2, "\\infty"),
  i(0),
}, { condition = in_math })

add_chain_rewrites({
  { trig = "\\sup=", body = "\\supseteq", priority = 2000 },
  { trig = "\\arg\\max", body = "\\operatorname*{arg\\,max}", priority = 2000 },
  { trig = "\\arg\\min", body = "\\operatorname*{arg\\,min}", priority = 2000 },
  { trig = "\\argmax", body = "\\operatorname*{arg\\,max}", priority = 2000 },
  { trig = "\\argmin", body = "\\operatorname*{arg\\,min}", priority = 2000 },
})

-- Greek-family snippets and postfix fixes.
for _, name in ipairs(greek) do
  add_regex_fmt("auto", "\\(" .. name .. "),%.", "\\boldsymbol{\\<>}", { cap(1) }, {
    condition = in_math,
  })
  add_regex_fmt("auto", "\\(" .. name .. ")%.,", "\\boldsymbol{\\<>}", { cap(1) }, {
    condition = in_math,
  })

  add_regex_text("auto", "([^%a\\])(" .. name .. ")", function(captures)
    return captures[1] .. "\\" .. captures[2]
  end, { condition = in_math })

  add_regex_fmt("auto", "\\(" .. name .. ")([A-Za-z])", "\\<> <>", {
    cap(1),
    cap(2),
  }, { condition = in_math })

  add_greek_suffix(name, { " sr" }, "\\<>^{2}", function(letter)
    return { letter }
  end)

  add_greek_suffix(name, { " cb", "cb" }, "\\<>^{3}", function(letter)
    return { letter }
  end, { priority = 2000 })

  add_greek_suffix(name, { " rd", "rd" }, "\\<>^{<>}<>", function(letter)
    return { letter, i(1), i(0) }
  end, { priority = 2000 })

  add_greek_suffix(name, { " conj", "conj" }, "\\<>^{*}", function(letter)
    return { letter }
  end, { priority = 2000 })

  for _, modifier in ipairs(greek_modifiers) do
    add_greek_suffix(name, { " " .. modifier.trig, modifier.trig }, modifier.body, function(letter)
      return { letter }
    end, { priority = modifier.priority or 2000 })
  end
end

-- Calculus and named operators.
add_fmt("regular", "par", "\\frac{ \\partial <> }{ \\partial <> } <>", {
  i(1, "y"),
  i(2, "x"),
  i(0),
}, { condition = in_math })

add_regex_fmt("regular", "pa([A-Za-z])([A-Za-z])", "\\frac{ \\partial <> }{ \\partial <> } ", {
  cap(1),
  cap(2),
}, { condition = in_math })

add_regex_text("auto", "([^\\])int", function(captures)
  return captures[1] .. "\\int"
end, {
  condition = in_math,
  priority = -1,
})

add_fmt("regular", "\\int", "\\int <> \\, d<> <>", {
  i(1),
  i(2, "x"),
  i(0),
}, {
  condition = in_math,
  wordTrig = false,
})

add_fmt("auto", "dint", "\\int_{<>}^{<>} <> \\, d<> <>", {
  i(1, "0"),
  i(2, "1"),
  i(3),
  i(4, "x"),
  i(0),
}, { condition = in_math })

add_backslash_commands(trig_functions)
add_spaced_commands(trig_functions, "[A-GI-Za-gi-z]")
add_spaced_commands(hyperbolic_functions, "[A-Za-z]")

-- Physics, chemistry, and common math environments.
add_fmt("auto", "bra", "\\bra{<>} <>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "ket", "\\ket{<>} <>", { i(1), i(0) }, { condition = in_math })
add_fmt("auto", "brk", "\\braket{ <> | <> } <>", {
  i(1),
  i(2),
  i(0),
}, { condition = in_math })
add_fmt("auto", "outer", "\\ket{<>} \\bra{<>} <>", {
  i(1, "\\psi"),
  rep(1),
  i(0),
}, { condition = in_math })

add_fmt("auto", "pu", "\\pu{ <> }", { i(1) }, { condition = in_math })
add_fmt("auto", "cee", "\\ce{ <> }", { i(1) }, { condition = in_math })
add_fmt("auto", "iso", "{}^{<>}_{<>}<>", {
  i(1, "4"),
  i(2, "2"),
  i(3, "He"),
}, { condition = in_math })

for _, item in ipairs({
  { trig = "pmat", env = "pmatrix" },
  { trig = "bmat", env = "bmatrix" },
  { trig = "Bmat", env = "Bmatrix" },
  { trig = "vmat", env = "vmatrix" },
  { trig = "Vmat", env = "Vmatrix" },
  { trig = "matrix", env = "matrix" },
}) do
  add_fmt("auto", item.trig, "\\begin{" .. item.env .. "}\n<>\n\\end{" .. item.env .. "}", {
    i(1),
  }, {
    condition = display_math,
  })

  add_fmt("auto", item.trig, "\\begin{" .. item.env .. "}<>\\end{" .. item.env .. "}", {
    i(1),
  }, {
    condition = inline_math,
    priority = -1,
  })
end

for _, item in ipairs({
  { trig = "cases", body = "\\begin{cases}\n<>\n\\end{cases}" },
  { trig = "align", body = "\\begin{aligned}\n<>\n\\end{aligned}" },
  { trig = "array", body = "\\begin{array}\n<>\n\\end{array}" },
}) do
  add_fmt("auto", item.trig, item.body, { i(1) }, { condition = in_math })
end

for _, item in ipairs({
  { trig = "ip", body = "\\langle <> \\rangle <>", priority = nil },
  { trig = "norm", body = "\\lvert <> \\rvert <>", priority = 1 },
  { trig = "Norm", body = "\\lVert <> \\rVert <>", priority = 1 },
  { trig = "ceil", body = "\\lceil <> \\rceil <>", priority = nil },
  { trig = "floor", body = "\\lfloor <> \\rfloor <>", priority = nil },
  { trig = "mod", body = "|<>|<>", priority = nil },
  { trig = "lr(", body = "\\left( <> \\right) <>", priority = nil },
  { trig = "lr{", body = "\\left\\{ <> \\right\\} <>", priority = nil },
  { trig = "lr[", body = "\\left[ <> \\right] <>", priority = nil },
  { trig = "lr|", body = "\\left| <> \\right| <>", priority = nil },
  { trig = "lrn", body = "\\left\\| <> \\right\\| <>", priority = nil },
  { trig = "set", body = "\\{ <> \\}<>", priority = nil },
}) do
  add_fmt("auto", item.trig, item.body, { i(1), i(0) }, {
    condition = in_math,
    priority = item.priority,
  })
end

add("auto", s(ctx("auto", "lra", {
  condition = in_math,
}), {
  t("\\left< "),
  i(1),
  t(" \\right> "),
  i(0),
}))

add_fmt("auto", "tayl", "<>(<> + <>) = <>(<>) + <>'(<>)<> + <>''(<>) \\frac{<>^{2}}{2!} + \\dots<>", {
  i(1, "f"),
  i(2, "x"),
  i(3, "h"),
  rep(1),
  rep(2),
  rep(1),
  rep(2),
  rep(3),
  rep(1),
  rep(2),
  rep(3),
  i(0),
}, {
  condition = in_math,
})

-- Small generators.
add_regex_text("auto", "iden(%d)", function(captures)
  local n = tonumber(captures[1])
  local rows = {}

  for row = 1, n do
    local cols = {}
    for col = 1, n do
      cols[#cols + 1] = row == col and "1" or "0"
    end
    rows[#rows + 1] = table.concat(cols, " & ")
  end

  return "\\begin{pmatrix}\n" .. table.concat(rows, " \\\\\n") .. "\n\\end{pmatrix}"
end, { condition = in_math })

return M

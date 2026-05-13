-- Main plugin specification that imports all plugin categories
return {
  { import = "plugins.ui" },
  { import = "plugins.lsp" },
  { import = "plugins.navigation" },
  { import = "plugins.edit" },
  { import = "plugins.git" },
}

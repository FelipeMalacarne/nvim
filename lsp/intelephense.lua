-- intelephense — PHP / Laravel LSP
-- vim.lsp.enable("intelephense") is called from lua/config/lsp.lua
-- This file MUST return a table.

-- These are intelephense false positives for Laravel: navigation (gd) works
-- but the diagnostic engine doesn't resolve vendor classes/traits correctly.
local SUPPRESSED = { "class.notFound", "trait.notFound" }

local default_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]

local function filter_diagnostics(err, result, ctx, config)
  if result and result.diagnostics then
    result.diagnostics = vim.tbl_filter(function(d)
      return not vim.tbl_contains(SUPPRESSED, d.code)
    end, result.diagnostics)
  end
  default_handler(err, result, ctx, config)
end

return {
  cmd       = { "intelephense", "--stdio" },
  filetypes = { "php", "blade" },
  handlers  = { ["textDocument/publishDiagnostics"] = filter_diagnostics },
  root_markers = {
    "composer.json",
    "artisan", -- Laravel project root
    ".git",
  },
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000,
      },
      environment = {
        phpVersion = "8.3",
      },
      stubs = {
        "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core",
        "ctype", "curl", "date", "dba", "dom", "enchant", "exif",
        "FFI", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext",
        "gmp", "hash", "iconv", "imap", "intl", "json", "ldap",
        "libxml", "mbstring", "meta", "mysqli", "oci8", "odbc",
        "openssl", "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql",
        "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix",
        "pspell", "readline", "Reflection", "session", "shmop",
        "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL",
        "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem",
        "sysvshm", "tidy", "tokenizer", "xml", "xmlreader",
        "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib",
        "laravel",
      },
    },
  },
}

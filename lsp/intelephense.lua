-- intelephense — PHP / Laravel LSP
-- vim.lsp.enable("intelephense") is called from lua/config/lsp.lua
-- This file MUST return a table.
return {
  cmd       = { "intelephense", "--stdio" },
  filetypes = { "php", "blade" },
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
        phpVersion = "8.5",
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

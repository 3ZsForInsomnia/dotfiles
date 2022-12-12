local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
  return
end

-- Installation location of jdtls by nvim-lsp-installer
local JDTLS_LOCATION = vim.fn.stdpath "data" .. "/lsp_servers/jdtls"

-- Data directory - change it to your liking
local HOME = os.getenv "HOME"
local WORKSPACE_PATH = HOME .. "/workspace/java/"

-- Only for Linux and Mac
local SYSTEM = "linux"
if vim.fn.has "mac" == 1 then
  SYSTEM = "mac"
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(JDTLS_LOCATION .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    JDTLS_LOCATION .. "/config_" .. SYSTEM,
    "-data",
    workspace_dir,
  },

  -- on_attach = require("config.lsp").on_attach,
  -- capabilities = require("config.lsp").capabilities,
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-11",
                path = "/Users/zachary.levine/.sdkman/candidates/java/adoptopenjdk-11.jdk/Contents/Home",
              },
              {
                name = "JavaSE-17",
                path = "/Users/zachary.levine/.sdkman/candidates/java/17.0.5-tem",
              },
            }
          }
        }
      },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
    },
    contentProvider = { preferred = "fernflower" },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },
  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {
      -- vim.fn.glob("/Users/zachary.levine/src/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
    },
  },
}
config['init_options'] = {
  bundles = {
    vim.fn.glob("path/to/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
  };
}
config['on_attach'] = function(client, bufnr)
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- Remove the option if you do not want that.
  -- You can use the `JdtHotcodeReplace` command to trigger it manually
  require('jdtls').setup_dap()
end

vim.list_extend(bundles, vim.split(vim.fn.glob("/Users/zachary.levine/src/vscode-java-test/server/*.jar", 1), "\n"))
config['init_options'] = {
  bundles = bundles;
}


-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)

-- Add the commands
require("jdtls.setup").add_commands()
-- vim.api.nvim_exec(
--   [[
-- command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
-- command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
-- command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
-- command! -buffer JdtJol lua require('jdtls').jol()
-- command! -buffer JdtBytecode lua require('jdtls').javap()
-- command! -buffer JdtJshell lua require('jdtls').jshell(),
--   ]],
--   false
-- )

vim.bo.shiftwidth = 2
vim.bo.tabstop = 2

-- local config = {
--     cmd = {'/Users/zachary.levine/jdt-language-server-latest/bin/jdtls'},
--     root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
--    -- Here you can configure eclipse.jdt.ls specific settings
--    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
--    -- for a list of options
--    settings = {
--      java = {
--        configuration = {
--          runtimes = {
--            {
--              name = "JavaSE-11",
--              path = "/Users/zachary.levine/.sdkman/candidates/java/adoptopenjdk-11.jdk/Contents/Home",
--            },
--            {
--              name = "JavaSE-17",
--              path = "/Users/zachary.levine/.sdkman/candidates/java/17.0.5-tem",
--            },
--          }
--        }
--      }
--    }
-- }
-- require('jdtls').start_or_attach(config)

--local config = {
--  cmd = {'/Users/zachary.levine/jdt-language-server-latest/bin/jdtls'},
--  -- The command that starts the language server
--  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
--  -- cmd = {
--    -- '/Users/zachary.levine/.sdkman/candidates/java/17.0.5-tem/bin',
--    -- '/Users/zachary.levine/jdt-language-server-latest/bin/jdtls',
--    -- '-Declipse.application=org.eclipse.jdt.ls.core.id1',
--    -- '-Dosgi.bundles.defaultStartLevel=4',
--    -- '-Declipse.product=org.eclipse.jdt.ls.core.product',
--    -- '-Dlog.protocol=true',
--    -- '-Dlog.level=ALL',
--    -- '-Xms1g',
--    -- '--add-modules=ALL-SYSTEM',
--    -- '--add-opens', 'java.base/java.util=ALL-UNNAMED',
--    -- '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
--    -- '-jar', '/Users/zachary.levine/jdt-language-server-latest/plugins/org.eclipse.equinox.common_3.17.0.v20221006-0914.jar',
--    -- '-configuration', '/Users/zachary.levine/jdt-language-server-latest/config_mac',
--    -- See `data directory configuration` section in the README
--    -- '-data', '/path/to/unique/per/project/workspace/folder'
--  -- },

--  -- This is the default if not provided, you can remove it. Or adjust as needed.
--  -- One dedicated LSP server & client will be started per unique root_dir
--  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

--  -- Here you can configure eclipse.jdt.ls specific settings
--  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
--  -- for a list of options
--  settings = {
--    java = {
--      configuration = {
--        runtimes = {
--          {
--            name = "JavaSE-11",
--            path = "/Users/zachary.levine/.sdkman/candidates/java/adoptopenjdk-11.jdk/Contents/Home",
--          },
--          {
--            name = "JavaSE-17",
--            path = "/Users/zachary.levine/.sdkman/candidates/java/17.0.5-tem",
--          },
--        }
--      }
--    }
--  },

--  -- Language server `initializationOptions`
--  -- You need to extend the `bundles` with paths to jar files
--  -- if you want to use additional eclipse.jdt.ls plugins.
--  --
--  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
--  --
--  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
--  init_options = {
--    bundles = {}
--  },
--}
---- This starts a new client & server,
---- or attaches to an existing client & server depending on the `root_dir`.
--require('jdtls').start_or_attach(config)

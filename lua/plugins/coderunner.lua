-- ====================================================================
-- ⚡ CONFIGURATION SWITCHES (Set these at the top)
-- ====================================================================

-- Execution window mode: "float", "tab", or "term"
local RUNNER_MODE = 1
-- C build type: 1 = Release (GCC -O2); 2 = Debug (Clang -g -fsanitize)
local C_BUILD_TYPE = 1
-- C++ build type: 1 = Release (G++ -O2); 2 = Debug (Clang++ -g -fsanitize)
local CPP_BUILD_TYPE = 1

-- ====================================================================
-- ⚙️ HELPER FUNCTIONS
-- ====================================================================

local function get_mode()
  -- Using the local RUNNER_MODE variable defined above
  if RUNNER_MODE == 1 then
    return "float"
  elseif RUNNER_MODE == 2 then
    return "tab"
  elseif RUNNER_MODE == 3 then
    return "term"
  else
    return "float" -- Default if RUNNER_MODE is set incorrectly
  end
end

local function get_c_mode()
  if C_BUILD_TYPE == 1 then
    -- Release Build (GCC -O2)
    return {
      "cd $dir &&",
      "mkdir -p out &&",
      "gcc -Wall -Wextra -O2 -o out/$fileNameWithoutExt $fileName -lm &&",
      "./out/$fileNameWithoutExt",
    }
  else
    -- Debug Build (Clang -g -fsanitize)
    return {
      "cd $dir &&",
      "mkdir -p out &&",
      "clang -Wall -Wextra -O2 -g -fsanitize=address,undefined -o out/$fileNameWithoutExt $fileName -lm &&",
      "./out/$fileNameWithoutExt",
    }
  end
end

local function get_cpp_mode()
  if CPP_BUILD_TYPE == 1 then
    -- Release Build (G++ -O2)
    return {
      "cd $dir &&",
      "mkdir -p out &&",
      "g++ -std=c++23 -Wall -Wextra -O2 -o out/$fileNameWithoutExt $fileName -lm &&",
      "./out/$fileNameWithoutExt",
    }
  else
    -- Debug Build (Clang++ -g -fsanitize)
    return {
      "cd $dir &&",
      "mkdir -p out &&",
      "clang++ -std=c++23 -Wall -Wextra -O2 -g -fsanitize=address,undefined -o out/$fileNameWithoutExt $fileName -lm &&",
      "./out/$fileNameWithoutExt",
    }
  end
end

-- ====================================================================
-- 💻 OS DETECTION AND FINAL CONFIG
-- ====================================================================

-- Detect OS
local is_windows = vim.uv.os_uname().sysname:match("Windows")

-- compiler configs
local filetype = {}

if is_windows then
  filetype = {
    cpp = {
      -- MSVC CL on Windows (unchanged)
      "cd $dir && cl /utf-8 /nologo /EHsc /O2 /std:c++latest /Zc:__cplusplus $fileName /Fe:$fileNameWithoutExt.exe && $fileNameWithoutExt.exe",
    },

    c = {
      -- MSVC CL on Windows (unchanged)
      "cd $dir && cl /utf-8 /nologo /O2 $fileName /Fe:$fileNameWithoutExt.exe && $fileNameWithoutExt.exe",
    },

    python = {
      "cd $dir &&",
      "python -u $fileName",
    },

    java = {
      "cd $dir &&", "javac $fileName &&", "java $fileNameWithoutExt"
    },

    rust = {
      "cd $dir &&",
      "rustc $fileName &&",
      "$dir/$fileNameWithoutExt"
    },

    typescript = {
      "deno run"
    },

  }
else
  filetype = {
    c = get_c_mode(),

    cpp = get_cpp_mode(),

    python = {
      "cd $dir &&",
      "python3 -u $fileName",
    },

    java = {
      "cd $dir &&", "javac $fileName &&", "java $fileNameWithoutExt"
    },

    rust = {
      "cd $dir &&",
      "rustc $fileName &&",
      "$dir/$fileNameWithoutExt"
    },

    typescript = {
      "deno run"
    },

  }
end

-- ====================================================================
-- 📦 RETURN CONFIG
-- ====================================================================

return {
  "CRAG666/code_runner.nvim",
  main = "code_runner",
  cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
  opts = function()
    return {
      mode = get_mode(),
      focus = true,
      startinsert = true,
      term = { position = "bot", size = 20 },
      float = {
        border = "rounded",
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5,
        border_hl = "FloatBorder",
        float_hl = "Normal",
        blend = 0,
      },
      filetype = filetype,
    }
  end,
  keys = {
    { "<F5>",       "<cmd>w<CR><cmd>RunCode<CR>", desc = "Save and Run Code" },
    { "<S-F5>",     "<cmd>RunClose<CR>",          desc = "Stop Running" },
    { "<C-F5>",     "<cmd>w<CR><cmd>RunFile<CR>", desc = "Save and Run File" },
    { "<leader>rc", "<cmd>w<CR><cmd>RunCode<CR>", desc = "Save and Run Code" },
    { "<leader>rf", "<cmd>w<CR><cmd>RunFile<CR>", desc = "Save and Run File" },
    { "<leader>rp", "<cmd>RunProject<CR>",        desc = "Run Project" },
    { "<leader>rx", "<cmd>RunClose<CR>",          desc = "Close Runner" },
  },
}

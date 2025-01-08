local M = {}

-- Store the window and buffer IDs globally
local preview_win = nil
local preview_buf = nil
local preview_dir = nil

-- Function to run kustomize build and display the output
function M.kustomize_build(dir)
  -- Check if the directory is valid; if not, use the parent directory of the file
  if vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.fnamemodify(dir, ":p:h")  -- Get the parent directory of the file
  end
  
  preview_dir = dir
  
  -- Construct the kustomize command with shellescape for safety
  local cmd = "kustomize build --enable-helm --load-restrictor=LoadRestrictionsNone " .. vim.fn.shellescape(dir) .. " 2>&1 | grep -v 'Warning'" 
  
  -- Run the command and capture the output
  local handle = io.popen(cmd)
  local output = handle:read("*a")
  handle:close()

  -- If the preview window doesn't exist, create it
  if not preview_win or not vim.api.nvim_win_is_valid(preview_win) then
    -- Create a vertical split to the right if the window doesn't exist
    vim.cmd("wincmd 99l")
    vim.cmd("rightbelow vsplit")  -- Open a vertical split to the right of the current window

    -- Create a new scratch buffer
    preview_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, preview_buf)  -- Set the new buffer in the current split
    preview_win = vim.api.nvim_get_current_win()  -- Keep reference to the window

    vim.api.nvim_buf_set_option(preview_buf, "buftype", "nofile")  -- No file backing
    vim.api.nvim_buf_set_option(preview_buf, "bufhidden", "wipe")  -- Automatically wipe buffer on close
    vim.api.nvim_buf_set_option(preview_buf, "swapfile", false)    -- Disable swapfile
  else
    -- If the preview window exists, reuse it and update the buffer
    vim.api.nvim_win_set_buf(preview_win, preview_buf)

    -- Optionally, reset the contents of the buffer (clear old content before updating)
    -- vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
  end

  -- Set the statusline to show the directory and timestamp
  vim.api.nvim_buf_set_option(preview_buf, "statusline", "K Preview: " .. dir:match(".*/k8s/(.*)") .. " @ " .. vim.fn.strftime("%H:%M:%S"))
  -- Populate the buffer with the output of kustomize build
  vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, vim.split(output, "\n"))

  -- Mark the buffer as YAML for Treesitter and linting
  vim.api.nvim_buf_set_option(preview_buf, "filetype", "yaml")
end

-- Setup function to define the Kb command
function M.setup()
  vim.api.nvim_create_user_command("Kp", function(args)
    M.kustomize_build(args.args)
  end, { nargs = 1, complete = "dir" })

  -- Autocmd to watch the directory for changes and rerun kustomize build, only for the previewer's directory
  vim.cmd([[
    augroup KustomizeWatcher
      autocmd!
      " Only trigger when file is in the preview directory
      autocmd BufWritePost **/*.yaml,**/*.yml lua require('swells.custom-plugins.kustomize-previewer').on_file_change(vim.fn.expand('%:p:h'))
    augroup END
  ]])
end

-- Function to handle file changes and check if it's in the previewer's directory
function M.on_file_change(file_dir)
  -- Only trigger if the file is in the directory of the previewer
  if preview_dir and vim.fn.expand('%:p:h'):find(preview_dir, 1, true) then
    M.kustomize_build(preview_dir)
  end
end

return M


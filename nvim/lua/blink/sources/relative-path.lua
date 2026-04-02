-- Custom path source that completes relative paths without requiring ./ prefix
-- Triggers on word/ patterns where word is a directory in cwd

local path_source = require('blink.cmp.sources.path')

---@class blink.cmp.RelativePathSource : blink.cmp.Source
local source = {}

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = vim.tbl_deep_extend('force', {
    get_cwd = function(_)
      return vim.fn.getcwd()
    end,
  }, opts or {})
  -- Create the underlying path source for actual completion
  self.path_source = path_source.new(self.opts)
  return self
end

function source:get_trigger_characters()
  return { '/' }
end

function source:get_completions(context, callback)
  local line = context.line:sub(1, context.cursor[2])

  -- Match word/ pattern at the end of line (without ./ or / prefix)
  -- Pattern: word boundary, then word chars, then /
  local prefix = line:match('([%w_%-%.]+/)$')
  if not prefix then
    callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
    return function() end
  end

  -- Check if this looks like it already has a recognized prefix
  if line:match('%./[%w_%-%.]+/$') or line:match('^/') or line:match('~/')
    or line:match('%$[%w_]+/') or line:match('%${[%w_]+}/') then
    -- Let the normal path source handle these
    callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
    return function() end
  end

  -- Get the directory path (everything before the last /)
  local dir_path = prefix:sub(1, -2) -- Remove trailing /

  local cwd = self.opts.get_cwd(context)
  local full_path = cwd .. '/' .. dir_path

  -- Check if this is actually a directory
  local stat = vim.uv.fs_stat(full_path)
  if not stat or stat.type ~= 'directory' then
    callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
    return function() end
  end

  -- Read directory contents
  local handle = vim.uv.fs_scandir(full_path)
  if not handle then
    callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
    return function() end
  end

  local items = {}
  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then break end

    -- Skip hidden files unless configured
    if not self.opts.show_hidden_files_by_default and name:sub(1, 1) == '.' then
      goto continue
    end

    local is_dir = type == 'directory'
    local insert_text = name .. (is_dir and '/' or '')

    table.insert(items, {
      label = insert_text,
      kind = is_dir and vim.lsp.protocol.CompletionItemKind.Folder
        or vim.lsp.protocol.CompletionItemKind.File,
      insertText = insert_text,
      sortText = (is_dir and '0' or '1') .. name, -- Directories first
    })

    ::continue::
  end

  callback({
    items = items,
    is_incomplete_forward = false,
    is_incomplete_backward = false,
  })
  return function() end
end

return source

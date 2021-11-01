local cmp = require'cmp'
local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })
  return self
end

function source:is_available()
  if vim.fn['iced#repl#is_connected']() then
    return true
  else
    return false
  end
end

function source:get_keyword_pattern()
  return [[\%([0-9a-zA-Z\*\+!\-_'?<>=\/.:]*\)]]
end

function source:get_trigger_characters()
  return {'/', '.', ':'}
end

local kinds = {
    c = cmp.lsp.CompletionItemKind.Class,
    f = cmp.lsp.CompletionItemKind.Function,
    k = cmp.lsp.CompletionItemKind.Keyword,
    m = cmp.lsp.CompletionItemKind.Function,
    n = cmp.lsp.CompletionItemKind.Module,
    s = cmp.lsp.CompletionItemKind.Function,
    v = cmp.lsp.CompletionItemKind.Variable,
}

function source:complete(request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset)
  vim.fn['iced#complete#candidates'](
    input,
    function(candidates)
      local items = {}
      for _, candidate in ipairs(candidates) do
        table.insert(
          items,
          { label = candidate.word, kind = kinds[candidate.kind] })
      end
      callback(items)
    end
  )
end

return source

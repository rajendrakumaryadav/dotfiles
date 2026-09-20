-- Polyfill vim.list.unique for Neovim < 0.12.
-- nvim-treesitter (post-rewrite) relies on this stdlib helper.
if vim.list == nil then
  vim.list = {}

  ---Removes duplicate values from a list-like table, keeping first occurrence.
  ---table is modified in place.
  ---@param t any[]
  ---@param key? fun(x: any): any
  ---@return any[]
  function vim.list.unique(t, key)
    local seen = {}
    local j = 1
    key = key or function(x)
      return x
    end

    for i = 1, #t do
      local v = t[i]
      local h = key(v)
      if not seen[h] then
        t[j] = v
        if h ~= nil then
          seen[h] = true
        end
        j = j + 1
      end
    end

    for i = j, #t do
      t[i] = nil
    end

    return t
  end
end
local M = {}

local qf_exists = function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            return true
        end
    end
    return false
end

-- Toggle quickfix but only if it contains data
M.toggle = function()
    if qf_exists() == true then
        vim.cmd("cclose")
        return
    end
      vim.cmd("copen")
end

return M

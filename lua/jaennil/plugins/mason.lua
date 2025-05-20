local M = {
    "mason-org/mason.nvim"
}

M.config = function()
    local mason = require("mason")
    mason.setup()
end

return M

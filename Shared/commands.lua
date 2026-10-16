
YRM = YRM or {}
YRM.Commands = YRM.Commands or {}

local registeredCommands = {}

local function normalizeName(name)
    if type(name) ~= "string" then return nil end

    name = name:lower()

    if not name:match("^[%w%-]+$") then
        return nil
    end

    return name
end

function YRM.RegisterCommand(name, callback, options)
    name = normalizeName(name)
    options = options or {}

    assert(name, "[YRM] Nom de commande invalide")
    assert(type(callback) == "function",
        "[YRM] Le callback doit être une fonction")

    registeredCommands[name] = {
        callback = callback,
        restricted = options.restricted == true,
    }
end

function YRM.UnregisterCommand(name)
    name = normalizeName(name)
    if not name then return end

    registeredCommands[name] = nil
end

function YRM.HandleCommand(message, player)
    if not YRM.Config.Commands.Enabled then
        return false
    end

    if type(message) ~= "string" then
        return false
    end

    local prefix = YRM.Config.Commands.Prefix or "/"

    if prefix == "" or message:sub(1, #prefix) ~= prefix then
        return false
    end

    local input = message:sub(#prefix + 1)
    local args = {}

    for value in input:gmatch("%S+") do
        args[#args + 1] = value
    end

    local name = normalizeName(table.remove(args, 1))
    if not name then return true end

    local command = registeredCommands[name]
    if not command then
        return false
    end

    command.callback(player, args, message)

    return true
end

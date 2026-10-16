YRM = YRM or {}

-- Marqueur de version : doit apparaître dans la console client à la connexion.
-- S'il n'apparaît pas, ce fichier n'est pas celui qui est exécuté.
print("[YRM] arrow_menu.lua charge (v3)")

local ActiveArrowMenu = nil

local function UpdateArrowMenu()
    local menu = ActiveArrowMenu
    if not menu then return end

    YRM.SendUi("YRM:UpdateArrowMenu", {
        id = menu.id,
        selected = menu.selected,
        items = menu.items
    })
end

local function FinishArrowMenu(action)
    local menu = ActiveArrowMenu
    if not menu then return end

    -- Empêche une double fermeture
    ActiveArrowMenu = nil

    YRM.SendUi("YRM:CloseArrowMenu", {
        id = menu.id
    })

    YRM.DisableUiInput()

    if menu.callback then
        local result = {
            action = action,
            index = menu.selected,
            item = menu.items[menu.selected + 1] or nil,
            values = {}
        }

        for _, item in ipairs(menu.items) do
            table.insert(result.values, {
                id = item.id,
                value = item.values
                    and item.values[(tonumber(item.valueIndex) or 0) + 1]
                    or nil
            })
        end

        menu.callback(result)
    end
end

function YRM.ShowArrowMenu(data, callback)
    print("[YRM] OpenArrowMenu appelee depuis arrow_menu.lua (v3)")

    data = data or {}

    -- Ferme l'ancien menu si nécessaire
    if ActiveArrowMenu then
        FinishArrowMenu("cancel")
    end

    local items = data.items or {}

    local selected = tonumber(data.selected) or 0
    selected = math.max(0, math.min(selected, math.max(#items - 1, 0)))

    ActiveArrowMenu = {
        id = YRM.GenerateUiId("arrow-menu"),
        title = tostring(data.title or "Menu"),
        position = data.position or "top-right",
        selected = selected,
        items = items,
        callback = callback
    }

    YRM.SendUi("YRM:OpenArrowMenu", {
        id = ActiveArrowMenu.id,
        title = ActiveArrowMenu.title,
        position = ActiveArrowMenu.position,
        selected = ActiveArrowMenu.selected,
        items = ActiveArrowMenu.items
    })
end

function YRM.CloseArrowMenu()
    FinishArrowMenu("cancel")
end

-- Navigation clavier gérée côté Lua (noms de touches nanos world :
-- Up, Down, Left, Right, Enter, Escape, BackSpace)
Input.Subscribe("KeyPress", function(key_name)
    local menu = ActiveArrowMenu

    if not menu then return end

    local key = tostring(key_name):lower()
    local count = #menu.items

    -- Option précédente
    if key == "up" then
        if count > 0 then
            menu.selected = (menu.selected - 1 + count) % count
            UpdateArrowMenu()
        end
        return false
    end

    -- Option suivante
    if key == "down" then
        if count > 0 then
            menu.selected = (menu.selected + 1) % count
            UpdateArrowMenu()
        end
        return false
    end

    local item = menu.items[menu.selected + 1]

    -- Modifier la valeur de l'option sélectionnée
    if key == "left" or key == "right" then
        if item and type(item.values) == "table" and #item.values > 0 then
            local valueIndex = tonumber(item.valueIndex) or 0
            local direction = (key == "right") and 1 or -1

            item.valueIndex =
                (valueIndex + direction + #item.values) % #item.values

            UpdateArrowMenu()
        end

        return false
    end

    -- Valider
    if key == "enter" then
        FinishArrowMenu("select")
        return false
    end

    -- Retour / annulation
    if key == "escape" or key == "backspace" then
        FinishArrowMenu("cancel")
        return false
    end
end)
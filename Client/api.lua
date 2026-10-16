
YRM = YRM or {}

local ActiveProgress = nil


local function EnableUiInput()
    Input.SetMouseEnabled(true)
    Input.SetInputEnabled(false)
end

local function DisableUiInput()
    Input.SetMouseEnabled(false)
    Input.SetInputEnabled(true)
end



function YRM.Notify(data)
    data = data or {}

    local notification = {
        title = tostring(data.title or "Information"),
        description = tostring(data.description or ""),
        type = data.type or "info",
        duration = tonumber(data.duration)
            or YRM.Config.NotificationDuration
            or 5000
    }

    YRM.SendUi("YRM:ShowNotification", notification)
end

-- Dialog
function YRM.OpenDialog(data, callback)
    data = data or {}

    local id = "dialog-" .. tostring(os.time()) .. "-"
        .. tostring(math.random(1000, 9999))

    if callback then
        YRM.RegisterUiCallback(id, callback)
    end

    EnableUiInput()

    YRM.SendUi("YRM:OpenDialog", {
        id = id,
        title = tostring(data.title or "Confirmation"),
        description = tostring(data.description or ""),
        confirmText = tostring(data.confirmText or "Confirmer"),
        cancelText = tostring(data.cancelText or "Annuler"),
    })
end

-- Formulaire
function YRM.OpenForm(data, callback)
    data = data or {}

    local id = "form-" .. tostring(os.time()) .. "-"
        .. tostring(math.random(1000, 9999))

    if callback then
        YRM.RegisterUiCallback(id, callback)
    end

    EnableUiInput()

    YRM.SendUi("YRM:OpenForm", {
        id = id,
        title = tostring(data.title or "Formulaire"),
        fields = data.fields or {},
    })
end

-- Menu contextuel
function YRM.OpenContextMenu(data)
    EnableUiInput()

    YRM.SendUi("YRM:OpenContextMenu", data or {})
end

-- Fin de la progress bar
local function FinishProgress(id, result)
    local progress = ActiveProgress

    if not progress or progress.id ~= id or progress.finished then
        return
    end

    progress.finished = true
    ActiveProgress = nil

    if progress.callback then
        progress.callback(result)
    end
end

-- Progress bar
function YRM.ProgressBar(data, callback)
    data = data or {}

    -- Annule la progression précédente si nécessaire
    if ActiveProgress then
        local previous = ActiveProgress
        ActiveProgress = nil
        previous.finished = true

        if previous.callback then
            previous.callback({
                cancelled = true
            })
        end
    end

    local id = "progress-" .. tostring(os.time()) .. "-"
        .. tostring(math.random(1000, 9999))

    ActiveProgress = {
        id = id,
        canCancel = data.canCancel == true,
        callback = callback,
        finished = false
    }

    YRM.SendUi("YRM:StartProgress", {
        id = id,
        label = tostring(data.label or "Chargement..."),
        duration = tonumber(data.duration)
            or YRM.Config.ProgressDuration
            or 3000,
        canCancel = data.canCancel == true
    })
end

-- Annulation de la progress bar avec X
Input.Subscribe("KeyPress", function(key_name)
    local progress = ActiveProgress

    if not progress then return end
    if not progress.canCancel then return end
    if key_name ~= "X" then return end

    local id = progress.id

    YRM.SendUi("YRM:CloseUI", {})

    FinishProgress(id, {
        cancelled = true
    })

    return false
end)


function YRM.OpenArrowMenu(data, callback)
    data = data or {}

    local id = "arrow-menu-" .. tostring(os.time()) .. "-"
        .. tostring(math.random(1000, 9999))

    if callback then
        YRM.RegisterUiCallback(id, callback)
    end


    YRM.SendUi("YRM:OpenArrowMenu", {
        id = id,
        title = tostring(data.title or "Menu"),
        position = data.position or "top-right",
        selected = tonumber(data.selected) or 0,
        items = data.items or {}
    })
end

-- À appeler lorsque le menu/UI se ferme
function YRM.CloseUiInput()
    DisableUiInput()
end

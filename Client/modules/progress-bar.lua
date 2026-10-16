
YRM = YRM or {}

local ActiveProgress = nil

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

function YRM.ProgressBar(data, callback)
    data = data or {}

    if ActiveProgress then
        local previous = ActiveProgress
        ActiveProgress = nil
        previous.finished = true

        if previous.callback then
            previous.callback({ cancelled = true })
        end
    end

    local id = YRM.GenerateUiId("progress")

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

Input.Subscribe("KeyPress", function(key_name)
    local progress = ActiveProgress

    if not progress or not progress.canCancel then
        return
    end

    if key_name ~= "X" then
        return
    end

    local id = progress.id

    YRM.SendUi("YRM:CloseUI", {})
    FinishProgress(id, { cancelled = true })

    return false
end)

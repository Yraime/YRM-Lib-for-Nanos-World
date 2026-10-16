
YRM = YRM or {}

function YRM.OpenDialog(data, callback)
    data = data or {}

    local id = YRM.GenerateUiId("dialog")

    if callback then
        YRM.RegisterUiCallback(id, callback)
    end

    YRM.EnableUiInput()

    YRM.SendUi("YRM:OpenDialog", {
        id = id,
        title = tostring(data.title or "Confirmation"),
        description = tostring(data.description or ""),
        confirmText = tostring(data.confirmText or "Confirmer"),
        cancelText = tostring(data.cancelText or "Annuler")
    })
end

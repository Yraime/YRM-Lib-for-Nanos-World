
YRM = YRM or {}

function YRM.OpenForm(data, callback)
    data = data or {}

    local id = YRM.GenerateUiId("form")

    if callback then
        YRM.RegisterUiCallback(id, callback)
    end

    YRM.EnableUiInput()

    YRM.SendUi("YRM:OpenForm", {
        id = id,
        title = tostring(data.title or "Formulaire"),
        fields = data.fields or {}
    })
end

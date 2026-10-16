
YRM = YRM or {}

function YRM.OpenContextMenu(data)
    YRM.EnableUiInput()
    YRM.SendUi("YRM:OpenContextMenu", data or {})
end

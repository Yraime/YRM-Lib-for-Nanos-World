
YRM = YRM or {}

function YRM.Notify(data)
    data = data or {}

    YRM.SendUi("YRM:ShowNotification", {
        title = tostring(data.title or "Information"),
        description = tostring(data.description or ""),
        type = data.type or "info",
        duration = tonumber(data.duration)
            or YRM.Config.NotificationDuration
            or 5000
    })
end

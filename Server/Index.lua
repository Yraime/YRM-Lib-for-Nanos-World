
YRM = YRM or {}

local function validNotification(data)
    if type(data) ~= "table" then
        return false
    end

    if type(data.description) ~= "string" then
        return false
    end

    if #data.description > YRM.Config.MaxNotificationLength then
        return false
    end

    return true
end

-- API serveur : envoyer une notification à un joueur.
function YRM.NotifyPlayer(player, data)
    if not player or not validNotification(data) then
        return false
    end

    player:CallRemoteEvent("YRM:ShowNotification", {
        title = tostring(data.title or "Information"),
        description = data.description,
        type = data.type or "info",
        duration = tonumber(data.duration)
            or YRM.Config.NotificationDuration,
    })

    return true
end

-- Exemple de relais client -> serveur.
-- Ne jamais utiliser ce relais pour autoriser une action RP.
Events.SubscribeRemote("YRM:RequestNotification", function(player, data)
    if not validNotification(data) then
        return
    end

    YRM.NotifyPlayer(player, {
        title = "Serveur",
        description = data.description,
        type = "info",
    })
end)

YRM.Log("Module serveur chargé")

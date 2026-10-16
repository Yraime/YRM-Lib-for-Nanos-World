YRM = YRM or {}

local webui = nil
local pendingActions = {}
local pendingUiEvents = {}
local uiReady = false
local uiOpen = false

-- Génération des identifiants
function YRM.GenerateUiId(prefix)
    return tostring(prefix or "ui") .. "-"
        .. tostring(os.time()) .. "-"
        .. tostring(math.random(1000, 9999))
end

-- Accès à l'état de la WebUI
function YRM.IsUiOpen()
    return uiOpen
end

function YRM.IsUiReady()
    return uiReady
end

-- S'assure que la WebUI est visible (elle est transparente et ne capte
-- ni la souris ni le clavier tant qu'elle n'a pas le focus).
local function EnsureVisible()
    if webui then
        webui:SetVisibility(WidgetVisibility.Visible)
    end
end

-- Gestion des entrées
function YRM.EnableUiInput()
    Input.SetMouseEnabled(true)
    Input.SetInputEnabled(false)

    if webui and uiReady then
        EnsureVisible()
        webui:SetFocus()
    end

    uiOpen = true
end

function YRM.DisableUiInput()
    Input.SetMouseEnabled(false)
    Input.SetInputEnabled(true)

    if webui then
        webui:RemoveFocus()
    end

    uiOpen = false
end

-- Reset de secours : souris et clavier rendus au jeu, WebUI visible
function YRM.ResetUiInput()
    YRM.DisableUiInput()
    EnsureVisible()
end

-- Callbacks des actions envoyées par la WebUI
function YRM.RegisterUiCallback(id, callback)
    if type(id) ~= "string" or type(callback) ~= "function" then
        return
    end

    pendingActions[id] = callback
end

local function onUiAction(action)
    if type(action) ~= "table" then return end
    if type(action.type) ~= "string" then return end

    if action.type == "YRM:CloseRequest" then
        YRM.CloseUi()
        return
    end

    Events.Call("YRM:UIAction", action)

    local id = action.id

    if id and pendingActions[id] then
        local callback = pendingActions[id]
        pendingActions[id] = nil

        local success, err = pcall(callback, action.data)

        if not success then
            Console.Log("[YRM] Erreur callback UI : " .. tostring(err))
        end
    end
end

-- Envoi des événements en attente
local function flushPendingUiEvents()
    if not webui or not uiReady then return end

    local events = pendingUiEvents
    pendingUiEvents = {}

    for _, event in ipairs(events) do
        webui:CallEvent(event.name, event.data)
    end
end

-- Création de la WebUI
local function createUi()
    if webui then return end

    webui = WebUI(
        YRM.Config.UiName,
        "file://UI/index.html",
        WidgetVisibility.Visible,
        true
    )

    webui:Subscribe("YRM:UIAction", function(...)
        local args = {...}
        onUiAction(args[#args])
    end)

    webui:Subscribe("Ready", function()
        uiReady = true

        YRM.Log("WebUI prête")

        webui:CallEvent("YRM:Initialize", YRM.Config)

        flushPendingUiEvents()

        Events.Call("YRM:UIReady")
    end)

    webui:Subscribe("Fail", function(_, code, message)
        Console.Log(
            "[YRM] WebUI error: "
            .. tostring(code)
            .. " "
            .. tostring(message)
        )
    end)
end

-- Envoi d'un événement Lua vers JavaScript
function YRM.SendUi(eventName, data)
    if type(eventName) ~= "string" then
        Console.Log("[YRM] Nom d'événement invalide")
        return
    end

    if not webui then
        createUi()
    end

    if not webui then
        Console.Log("[YRM] WebUI indisponible")
        return
    end

    data = data or {}

    if not uiReady then
        table.insert(pendingUiEvents, {
            name = eventName,
            data = data
        })
        return
    end

    -- Correction du bug "souris visible mais rien affiché" :
    -- quelle que soit l'UI ouverte (menu, progress bar, notif...),
    -- la WebUI est forcée visible avant l'envoi.
    EnsureVisible()

    webui:CallEvent(eventName, data)
end

-- Fermeture de l'interface
-- On rend la souris et le clavier au jeu mais on NE CACHE PLUS la WebUI :
-- la masquer empêchait les ouvertures suivantes qui n'appellent pas
-- EnableUiInput (menu fléché, progress bar, notifications).
function YRM.CloseUi()
    YRM.DisableUiInput()
    YRM.Log("Interface fermée")
end

-- Initialisation
Events.SubscribeRemote("YRM:ShowNotification", function(data)
    data = data or {}

    YRM.SendUi("YRM:ShowNotification", {
        title = tostring(data.title or "Information"),
        description = tostring(data.description or ""),
        type = data.type or "info",
        duration = tonumber(data.duration)
            or YRM.Config.NotificationDuration
    })
end)

createUi()

YRM.Log("Core chargé")
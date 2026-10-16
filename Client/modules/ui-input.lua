YRM = YRM or {}

-- Propriétaires actuels de l'input UI (souris visible, input jeu coupé).
-- Chaque UI qui en a besoin s'enregistre ; la souris n'est rendue
-- au jeu que lorsque plus aucune UI n'en a besoin.
local Owners = {}
local OwnerCount = 0

local DEFAULT_OWNER = "__default"

local function Apply()
    if OwnerCount > 0 then
        Input.SetMouseEnabled(true)
        Input.SetInputEnabled(false)
    else
        Input.SetMouseEnabled(false)
        Input.SetInputEnabled(true)
    end
end

-- Active l'input UI. `owner` est optionnel (ex: l'id du menu).
-- Appeler deux fois avec le même owner ne cumule pas : pas de désynchronisation.
function YRM.EnableUiInput(owner)
    owner = owner or DEFAULT_OWNER

    if not Owners[owner] then
        Owners[owner] = true
        OwnerCount = OwnerCount + 1
    end

    Apply()
end

-- Désactive l'input UI.
--  - Avec un owner : retire seulement celui-ci.
--  - Sans argument : retire TOUT (fermeture "classique", jamais bloquée).
function YRM.DisableUiInput(owner)
    if owner == nil then
        Owners = {}
        OwnerCount = 0
    elseif Owners[owner] then
        Owners[owner] = nil
        OwnerCount = math.max(0, OwnerCount - 1)
    end

    Apply()
end

function YRM.CloseUiInput()
    YRM.DisableUiInput()
end

function YRM.IsUiInputEnabled()
    return OwnerCount > 0
end

-- Reset de secours : remet souris et input jeu à zéro, quoi qu'il arrive.
function YRM.ResetUiInput()
    Owners = {}
    OwnerCount = 0
    Apply()
end

-- Si le package est rechargé, ne laisse jamais la souris bloquée.
Package.Subscribe("Unload", function()
    YRM.ResetUiInput()
end)
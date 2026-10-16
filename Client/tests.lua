
-- yrm-lib : commandes de test client


Chat.Subscribe("PlayerSubmit", function(message, player)
    if YRM.HandleCommand(message, player) then
        return false
    end

    return true
end)


YRM.RegisterCommand(YRM.Config.TestCommands.Notify, function()
    YRM.Notify({
        title = "Test YRM",
        description = "Le module de notifications fonctionne.",
        type = "success",
        duration = 5000
    })
end)

YRM.RegisterCommand(YRM.Config.TestCommands.Dialog, function()
    YRM.OpenDialog({
        title = "Confirmation",
        description = "Souhaites-tu continuer ?",
        confirmText = "Confirmer",
        cancelText = "Annuler",
    }, function(result)
        YRM.Notify({
            title = "Résultat",
            description = result and result.confirmed
                and "Confirmation acceptée."
                or "Confirmation annulée.",
        })
    end)
end)

YRM.RegisterCommand(YRM.Config.TestCommands.Form, function()
    YRM.OpenForm({
        title = "Test de formulaire",
        fields = {
            {
                name = "firstname",
                label = "Prénom",
                type = "text",
                required = true,
                maxLength = 40,
            },
            {
                name = "age",
                label = "Âge",
                type = "number",
                required = true,
            },
        },
    }, function(result)
        if result and not result.cancelled then
            YRM.Notify({
                title = "Formulaire envoyé",
                description = "Prénom : "
                    .. tostring(result.values.firstname),
                type = "success",
            })
        end
    end)
end)

YRM.RegisterCommand(YRM.Config.TestCommands.Menu, function()
    YRM.OpenContextMenu({
        id = "test-menu",
        title = "Menu YRM",
        options = {
            { id = "first", label = "Première action" },
            { id = "second", label = "Deuxième action" },
        },
    })
end)

YRM.RegisterCommand(YRM.Config.TestCommands.ProgressBar, function()
    YRM.ProgressBar({
        label = "Téléchargement",
        duration = 10000,
        canCancel = true,
    }, function(result)
        if result and result.cancelled then
            YRM.Notify({
                title = "Progression",
                description = "Opération annulée.",
                type = "warning",
            })
        else
            YRM.Notify({
                title = "Progression",
                description = "Opération terminée.",
                type = "success",
            })
        end
    end)
end)

YRM.RegisterCommand(YRM.Config.TestCommands.ArrowMenu, function()

    YRM.ShowArrowMenu({
        title = "Menu joueur",
        position = "top-left",

        items = {
            {
                id = "job",
                label = "Métier",
                values = {
                    "Policier",
                    "Mécanicien",
                    "Médecin"
                },
                valueIndex = 0
            },
            {
                id = "inventory",
                label = "Inventaire",
                description = "Ouvrir l'inventaire"
            },
            {
                id = "money",
                label = "Argent",
                values = {
                    "Personnel",
                    "Banque",
                    "Entreprise"
                },
                valueIndex = 0
            }
        }

    }, function(result)

        if not result then
            return
        end

        if result.action == "cancel" then
            print("Menu fermé")
            return
        end

        if result.action == "select" then

            local item = result.item

            if not item then
                return
            end

            print("Option sélectionnée :", item.id)

            if item.id == "job" then
                local job = item.values[
                    (tonumber(item.valueIndex) or 0) + 1
                ]

                print("Métier choisi :", job)

            elseif item.id == "inventory" then
                print("Ouverture de l'inventaire")

            elseif item.id == "money" then
                local account = item.values[
                    (tonumber(item.valueIndex) or 0) + 1
                ]

                print("Compte choisi :", account)
            end
        end
    end)
end)

YRM.Log("Commandes de test chargées")

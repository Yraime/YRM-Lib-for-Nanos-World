# YRM Lib (yrm-lib)

> 🚧 **Statut : En cours de développement.** Ne pas utiliser pour un projet important.

> **Bibliothèque UI et utilitaire modulaire pour nanos world.**  
> Développée sur mesure avec une architecture modulaire en **Lua** et **WebUI** (HTML/CSS/JS).

---

## 📦 Aperçu & Fonctionnalités

`yrm-lib` fournit un ensemble de composants d'interface pour créer un serveur ou mode de jeux complet sans réinventer la roue.

### 🌟 Modules UI inclus
* 🔔 **Notifications** (`YRM.Notify`) : Messages contextuels stylisés avec durée paramétrable.
* 💬 **Boîtes de dialogue** (`YRM.OpenDialog`) : Modales de confirmation interactives avec callbacks.
* 📝 **Formulaires dynamiques** (`YRM.OpenForm`) : Saisie de données avec gestion des champs (`text`, `number`, validation, etc.).
* 📋 **Menus contextuels** (`YRM.OpenContextMenu`) : Listes d'actions rapides sélectionnables.
* ⏳ **Barres de progression** (`YRM.ProgressBar`) : Indicateur visuel d'actions avec option d'annulation.
* 🎯 **Menus fléchés / Arrow Menu** (`YRM.ShowArrowMenu`) : Menu HUD latéral avec défilement de valeurs (métiers, inventaire, argent).

## Exemples d'utilisation

### 1. Notification

```lua
YRM.Notify({
    title = "Bienvenue",
    description = "La bibliothèque fonctionne correctement.",
    type = "success",
    duration = 5000
})
```

Types courants utilisés dans les exemples : `success`, `warning` et `error`.

### 2. Dialogue de confirmation

```lua
YRM.OpenDialog({
    title = "Confirmation",
    description = "Souhaites-tu continuer ?",
    confirmText = "Confirmer",
    cancelText = "Annuler",
}, function(result)
    if result and result.confirmed then
        print("Confirmation acceptée")
    else
        print("Confirmation annulée")
    end
end)
```

### 3. Formulaire

```lua
YRM.OpenForm({
    title = "Créer un personnage",
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
        print("Prénom :", result.values.firstname)
        print("Âge :", result.values.age)
    end
end)
```

### 4. Menu contextuel

```lua
YRM.OpenContextMenu({
    id = "player-menu",
    title = "Menu joueur",
    options = {
        {
            id = "profile",
            label = "Voir le profil",
        },
        {
            id = "inventory",
            label = "Ouvrir l'inventaire",
        },
    },
})
```

### 5. Barre de progression

```lua
YRM.ProgressBar({
    label = "Chargement...",
    duration = 10000,
    canCancel = true,
}, function(result)
    if result and result.cancelled then
        print("Opération annulée")
    else
        print("Opération terminée")
    end
end)
```

### 6. Menu à flèches

```lua
YRM.ShowArrowMenu({
    title = "Choisir un métier",
    position = "top-left",
    items = {
        {
            id = "job",
            label = "Métier",
            values = {
                "Policier",
                "Mécanicien",
                "Médecin",
            },
            valueIndex = 0,
        },
    },
}, function(result)
    if not result then
        return
    end

    if result.action == "cancel" then
        print("Menu fermé")
        return
    end

    if result.action == "select" and result.item then
        print("Option sélectionnée :", result.item.id)
    end
end)
```

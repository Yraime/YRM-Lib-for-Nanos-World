# YRM Lib (yrm-lib)

## ⚠️🛠️ Nouvelle version disponible : `0.2.0` — Pensez à mettre à jour !

> 🚀 **La version `0.2.0` est disponible depuis le 28/10 !**
>
> 🔄 **N'oubliez pas de mettre à jour `yrm-lib`** pour profiter des dernières améliorations et corrections.


> **Bibliothèque UI et utilitaire modulaire pour nanos world.**  
> Développée sur mesure avec une architecture modulaire en **Lua** et **WebUI** (HTML/CSS/JS).

---

## 🔗 GitHub & Documentation

Retrouvez le projet, ses mises à jour et sa documentation ici :

- 📚 **Documentation officielle :** [Consulter la documentation](https://yraime.github.io/yraime.docs/docs)
- 🐙 **GitHub :** Retrouvez le dépôt du projet pour consulter le code source et suivre son évolution.

> 💬 **Un problème avec la documentation ?**
>
> La documentation peut contenir des erreurs ou des informations manquantes. Si vous rencontrez un problème, si une explication n'est pas claire ou si vous ne trouvez pas ce que vous cherchez, vous pouvez toujours **me contacter en MP sur Discord**. Je ferai de mon mieux pour vous aider !

---

## ⚙️ Dépendances

> ⚠️ **`yrm-core` est une dépendance obligatoire !**

`yrm-lib` nécessite **`yrm-core`** pour fonctionner correctement.

Assurez-vous que `yrm-core` est installé et configuré avant d'utiliser `yrm-lib`. Sans cette dépendance, certaines fonctionnalités de la bibliothèque risquent de ne pas fonctionner correctement.

---

## 📦 Aperçu & Fonctionnalités

`yrm-lib` fournit un ensemble de composants d'interface pour créer un serveur ou un mode de jeu complet sans réinventer la roue.

### 🌟 Modules UI inclus

- 🔔 **Notifications** (`YRM.Notify`) : Messages contextuels stylisés avec durée paramétrable.
- 💬 **Boîtes de dialogue** (`YRM.OpenDialog`) : Modales de confirmation interactives avec callbacks.
- 📝 **Formulaires dynamiques** (`YRM.OpenForm`) : Saisie de données avec gestion des champs (`text`, `number`, validation, etc.).
- 📋 **Menus contextuels** (`YRM.OpenContextMenu`) : Listes d'actions rapides sélectionnables.
- ⏳ **Barres de progression** (`YRM.ProgressBar`) : Indicateur visuel d'actions avec option d'annulation.
- 🎯 **Menus fléchés / Arrow Menu** (`YRM.ShowArrowMenu`) : Menu HUD latéral avec défilement de valeurs (métiers, inventaire, argent).

## Exemples d'utilisation

### 1. Notification

```lua
YRM.Notify({
    title = "Bienvenue",
    description = "La bibliothèque fonctionne correctement.",
    position = "top-left",
    type = "success", -- accent, success, error, warning
    duration = 5000
})
```

Types courants utilisés dans les exemples : `success`, `warning` et `error`.

### 2. Dialogue de confirmation

```lua
YRM.OpenDialog({
    title = "Confirmation",
    description = "Souhaites-tu continuer ?",
    position = "center", -- center, top, bottom
    confirmText = "Confirmer",
    canCancel = true,
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
    title = "Exemple de formulaire",
    fields = {
        {
            name = "password",
            label = "Mot de passe",
            type = "password",
            required = true
        },
        {
            name = "search",
            label = "Rechercher",
            type = "search",
            placeholder = "Rechercher..."
        },
        {
            name = "website",
            label = "Site web",
            type = "url"
        },
        {
            name = "date",
            label = "Date",
            type = "date"
        },
        {
            name = "time",
            label = "Heure",
            type = "time"
        },
        {
            name = "color",
            label = "Couleur",
            type = "color",
            default = "#552583"
        },
        {
            name = "volume",
            label = "Volume",
            type = "range",
            min = 0,
            max = 100,
            default = 50
        },
        {
            name = "notifications",
            label = "Notifications",
            type = "toggle",
            default = true
        },
        {
            name = "accepted",
            label = "J'accepte",
            type = "checkbox"
        },
        {
            name = "rank",
            label = "Grade",
            type = "select",
            options = {
                { label = "Recrue", value = "recruit" },
                { label = "Membre", value = "member" },
                { label = "Chef", value = "leader" }
            },
            default = "member"
        },
        {
            name = "rating",
            label = "Note",
            type = "rating",
            max = 5,
            required = true
        },
        {
            name = "locked",
            label = "Champ désactivé",
            type = "text",
            default = "Non modifiable",
            disabled = true
        }
    }
}, function(result)
    if result.cancelled then return end

    local values = result.values

    print("Couleur :", values.color)
    print("Volume :", values.volume)
    print("Notifications :", values.notifications)
    print("Accepté :", values.accepted)
    print("Grade :", values.rank)
    print("Note :", values.rating)
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

---

> 📢 **Rappel :** La version `0.2.0` est disponible ! Pensez à mettre à jour votre bibliothèque.
>
> ⚙️ **Dépendance obligatoire :** N'oubliez pas d'installer `yrm-core`.
>
> 📚 Consultez la [documentation officielle](https://yraime.github.io/yraime.docs/docs) pour découvrir les fonctionnalités et leur utilisation.
>
> 💬 En cas de problème avec la documentation ou la bibliothèque, n'hésitez pas à me contacter en MP sur Discord !


"use strict";

(() => {
    const M = window.YRMModules;

    if (!M) {
        console.error("[yrm-lib] YRMModules introuvable");
        return;
    }

    let activeMenu = null;

    const POSITIONS = [
        "top-right",
        "top-left",
        "bottom-right",
        "bottom-left"
    ];

    const FOOTER_TEXT =
        "↑ ↓ Naviguer   ← → Choisir   Entrée Valider   Échap Retour";

    /**
     * Récupère le conteneur des overlays.
     */
    function getOverlays() {
        let overlays = document.querySelector("#yrm-overlays");

        if (!overlays) {
            console.error(
                "[yrm-lib] Conteneur #yrm-overlays introuvable"
            );
        }

        return overlays;
    }

    /**
     * Crée un élément avec les classes et le contenu fournis.
     */
    function createElement(tag, className, content) {
        const element = M.element(tag, className);

        if (content !== undefined && content !== null) {
            element.textContent = String(content);
        }

        return element;
    }

    /**
     * Vérifie et normalise l'index sélectionné.
     */
    function normalizeIndex(index, length) {
        if (length <= 0) {
            return 0;
        }

        const parsed = Number(index);

        const value = Number.isFinite(parsed)
            ? Math.trunc(parsed)
            : 0;

        return Math.max(0, Math.min(value, length - 1));
    }

    /**
     * Ferme le menu actuellement affiché.
     */
    function closeArrowMenu(data = {}) {
        if (!activeMenu) {
            return;
        }

        if (
            data &&
            data.id !== undefined &&
            data.id !== null &&
            data.id !== activeMenu.id
        ) {
            return;
        }

        activeMenu.panel.remove();
        activeMenu = null;
    }

    /**
     * Affiche les lignes du menu.
     */
    function renderMenu(selected) {
        const menu = activeMenu;

        if (!menu) {
            return;
        }

        if (selected !== undefined && selected !== null) {
            menu.selected = normalizeIndex(
                selected,
                menu.items.length
            );
        } else {
            menu.selected = normalizeIndex(
                menu.selected,
                menu.items.length
            );
        }

        menu.list.replaceChildren();

        menu.items.forEach((item, index) => {
            const isSelected = index === menu.selected;

            const row = createElement(
                "div",
                `yrm-arrow-item${isSelected ? " selected" : ""}`
            );

            row.dataset.index = String(index);

            if (isSelected) {
                row.setAttribute("aria-current", "true");
            }

            const label = createElement(
                "span",
                "yrm-arrow-label",
                item.label || "Option"
            );

            row.append(label);

            if (
                Array.isArray(item.values) &&
                item.values.length > 0
            ) {
                const valueIndex = normalizeIndex(
                    item.valueIndex,
                    item.values.length
                );

                const value = createElement(
                    "span",
                    "yrm-arrow-value"
                );

                const previous = createElement(
                    "span",
                    "yrm-arrow-value-prev",
                    "‹"
                );

                const current = createElement(
                    "span",
                    "yrm-arrow-value-current",
                    item.values[valueIndex]
                );

                const next = createElement(
                    "span",
                    "yrm-arrow-value-next",
                    "›"
                );

                value.append(previous, current, next);
                row.append(value);
            } else if (
                item.description !== undefined &&
                item.description !== null &&
                item.description !== ""
            ) {
                row.append(
                    createElement(
                        "span",
                        "yrm-arrow-value",
                        item.description
                    )
                );
            }

            menu.list.append(row);
        });
    }

    /**
     * Ouvre un nouveau menu.
     */
    function openArrowMenu(data = {}) {
        // Supprime le menu précédent sans envoyer de callback Lua.
        closeArrowMenu();

        const overlays = getOverlays();

        if (!overlays) {
            return;
        }

        const items = Array.isArray(data.items)
            ? data.items
            : [];

        const position = POSITIONS.includes(data.position)
            ? data.position
            : "top-right";

        const panel = createElement(
            "section",
            `yrm-panel yrm-arrow-menu position-${position}`
        );

        panel.dataset.menuId = String(data.id ?? "");

        panel.setAttribute("role", "menu");

        const title = createElement(
            "div",
            "yrm-title",
            data.title || "Menu"
        );

        const list = createElement(
            "div",
            "yrm-arrow-list"
        );

        list.setAttribute("role", "presentation");

        const footer = createElement(
            "div",
            "yrm-arrow-footer",
            FOOTER_TEXT
        );

        panel.append(title, list, footer);

        activeMenu = {
            id: data.id,
            panel,
            list,
            items,
            selected: normalizeIndex(
                data.selected,
                items.length
            )
        };

        // Insère le panel avant de dessiner ses lignes.
        overlays.appendChild(panel);

        renderMenu(data.selected);

        console.log("[yrm-lib] Arrow menu ouvert", {
            id: data.id,
            position,
            items: items.length
        });
    }

    /**
     * Met à jour la sélection ou les options.
     */
    function updateArrowMenu(data = {}) {
        if (!activeMenu) {
            console.warn(
                "[yrm-lib] Mise à jour ignorée : aucun menu ouvert"
            );
            return;
        }

        if (
            data.id !== undefined &&
            data.id !== null &&
            data.id !== activeMenu.id
        ) {
            return;
        }

        if (Array.isArray(data.items)) {
            activeMenu.items = data.items;
        }

        renderMenu(data.selected);
    }

    /**
     * Enregistre les événements envoyés par Lua.
     */
    Events.Subscribe(
        "YRM:OpenArrowMenu",
        openArrowMenu
    );

    Events.Subscribe(
        "YRM:UpdateArrowMenu",
        updateArrowMenu
    );

    Events.Subscribe(
        "YRM:CloseArrowMenu",
        closeArrowMenu
    );

    /**
     * API interne de yrm-lib.
     */
    M.arrowMenu = openArrowMenu;
    M.updateArrowMenu = updateArrowMenu;
    M.closeArrowMenu = closeArrowMenu;

    console.log("[yrm-lib] Arrow menu chargé");
})();

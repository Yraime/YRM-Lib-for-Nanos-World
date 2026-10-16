
"use strict";

(() => {
    const M = window.YRMModules;
    const overlays = document.querySelector("#yrm-overlays");

    function contextMenu(data = {}) {
        M.clearOverlay();

        const panel = M.element("section", "yrm-panel");

        panel.append(
            M.element("div", "yrm-title", data.title || "Actions")
        );

        const menu = M.element("div", "yrm-menu");

        (Array.isArray(data.options) ? data.options : []).forEach(option => {
            if (!option || typeof option.label !== "string") return;

            menu.append(
                M.button(option.label, () => {
                    M.clearOverlay();

                    M.emit("YRM:ContextAction", data.id, {
                        action: String(option.id || "")
                    });

                    M.requestClose();
                })
            );
        });

        const actions = M.element("div", "yrm-actions");

        actions.append(
            M.button("Fermer", () => {
                M.clearOverlay();
                M.requestClose();
            })
        );

        panel.append(menu, actions);
        overlays.append(panel);
    }

    Events.Subscribe("YRM:OpenContextMenu", contextMenu);

    M.contextMenu = contextMenu;
})();


"use strict";

(() => {
    const M = window.YRMModules;
    const overlays = document.querySelector("#yrm-overlays");

    function dialog(data = {}) {
        M.clearOverlay();

        const panel = M.element("section", "yrm-panel");

        panel.append(
            M.element("div", "yrm-title", data.title || "Confirmation"),
            M.element("div", "yrm-description", data.description || "")
        );

        const actions = M.element("div", "yrm-actions");

        actions.append(
            M.button(data.cancelText || "Annuler", () => {
                M.clearOverlay();

                M.emit("YRM:DialogResult", data.id, {
                    confirmed: false
                });

                M.requestClose();
            }),

            M.button(data.confirmText || "Confirmer", () => {
                M.clearOverlay();

                M.emit("YRM:DialogResult", data.id, {
                    confirmed: true
                });

                M.requestClose();
            }, true)
        );

        panel.append(actions);
        overlays.append(panel);
    }

    Events.Subscribe("YRM:OpenDialog", dialog);

    M.dialog = dialog;
})();

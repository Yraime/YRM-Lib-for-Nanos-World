
"use strict";

Events.Subscribe("YRM:Initialize", () => {
    console.log("[YRM] WebUI initialisée");

    console.log("[YRM] Modules chargés :", {
        notifications: typeof YRMModules.notify === "function",
        dialog: typeof YRMModules.dialog === "function",
        form: typeof YRMModules.form === "function",
        contextMenu: typeof YRMModules.contextMenu === "function",
        progress: typeof YRMModules.startProgress === "function"
    });
});

document.addEventListener("keydown", event => {
    if (event.key === "Escape") {
        event.preventDefault();
        YRMModules.requestClose();
    }
});

document.querySelector("#yrm-overlays").addEventListener("click", event => {
    if (event.target === event.currentTarget) {
        YRMModules.clearOverlay();
        YRMModules.closeProgress?.();
        YRMModules.requestClose();
    }
});

"use strict";

(() => {
    const M = window.YRMModules;
    const root = document.querySelector("#yrm-notifications");

    console.log("[YRM] notifications.js chargé", !!root);

    function notify(data = {}) {
        console.log("[YRM] Notification reçue :", data);

        if (!root) return;

        const toast = document.createElement("article");
        toast.className = `yrm-toast ${data.type || "info"}`;

        const title = document.createElement("div");
        title.className = "yrm-title";
        title.textContent = data.title || "Information";

        const description = document.createElement("div");
        description.className = "yrm-description";
        description.textContent = data.description || "";

        toast.append(title, description);
        root.append(toast);

        setTimeout(() => toast.remove(), Number(data.duration) || 4000);
    }

    Events.Subscribe("YRM:ShowNotification", notify);
    M.notify = notify;
})();
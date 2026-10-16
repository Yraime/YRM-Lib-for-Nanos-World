
"use strict";

(() => {
    const M = window.YRMModules;
    const overlays = document.querySelector("#yrm-overlays");

    function form(data = {}) {
        M.clearOverlay();

        const panel = M.element("form", "yrm-panel");

        panel.append(
            M.element("div", "yrm-title", data.title || "Formulaire")
        );

        const fields = M.element("div", "yrm-fields");
        const controls = [];

        (Array.isArray(data.fields) ? data.fields : []).forEach(field => {
            if (!field || typeof field.name !== "string") return;

            const label = M.element(
                "label",
                "",
                field.label || field.name
            );

            const input = M.element(
                field.type === "textarea" ? "textarea" : "input"
            );

            input.name = field.name;
            input.required = field.required === true;

            if (field.type !== "textarea") {
                input.type = ["text", "number", "email"].includes(field.type)
                    ? field.type
                    : "text";
            }

            if (field.maxLength) {
                input.maxLength = Math.max(
                    1,
                    Math.min(500, Number(field.maxLength))
                );
            }

            label.append(input);
            fields.append(label);
            controls.push(input);
        });

        const actions = M.element("div", "yrm-actions");

        actions.append(
            M.button("Annuler", () => {
                M.clearOverlay();

                M.emit("YRM:FormResult", data.id, {
                    cancelled: true
                });

                M.requestClose();
            })
        );

        const submit = M.button("Valider", () => {});
        submit.type = "submit";
        submit.classList.add("primary");

        actions.append(submit);
        panel.append(fields, actions);

        panel.addEventListener("submit", event => {
            event.preventDefault();

            const values = {};

            for (const control of controls) {
                if (!control.reportValidity()) return;
                values[control.name] = control.value;
            }

            M.clearOverlay();

            M.emit("YRM:FormResult", data.id, {
                cancelled: false,
                values
            });

            M.requestClose();
        });

        overlays.append(panel);
    }

    Events.Subscribe("YRM:OpenForm", form);

    M.form = form;
})();

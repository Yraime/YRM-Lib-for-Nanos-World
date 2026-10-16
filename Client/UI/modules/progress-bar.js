"use strict";

(() => {
    const M = window.YRMModules;
    const root = document.querySelector("#yrm-progress");

    let progressTimer = null;
    let activeProgress = null;

    function stopTimer() {
        if (progressTimer !== null) {
            window.clearInterval(progressTimer);
            progressTimer = null;
        }
    }

    function closeProgress() {
        stopTimer();
        activeProgress = null;
        root?.replaceChildren();
    }

    function cancelProgress() {
        if (!activeProgress || !activeProgress.canCancel) return;

        const progress = activeProgress;

        closeProgress();

        M.emit("YRM:ProgressResult", progress.id, {
            cancelled: true
        });
    }

    function startProgress(data = {}) {
        closeProgress();

        if (!root) return;

        const progress = {
            id: data.id ?? null,
            canCancel: data.canCancel === true
        };

        activeProgress = progress;

        const panel = M.element("div", "yrm-panel");

        const label = M.element(
            "div",
            "yrm-title",
            data.label || "Chargement..."
        );

        const track = M.element("div", "yrm-track");
        const fill = M.element("div", "yrm-fill");

        track.append(fill);
        panel.append(label, track);

        if (progress.canCancel) {
            panel.append(
                M.button("Annuler (X)", cancelProgress)
            );
        }

        root.append(panel);

        const duration = Math.max(
            100,
            Math.min(Number(data.duration) || 3000, 120000)
        );

        const start = performance.now();

        progressTimer = window.setInterval(() => {
            if (activeProgress !== progress) {
                stopTimer();
                return;
            }

            const percent = Math.min(
                100,
                ((performance.now() - start) / duration) * 100
            );

            fill.style.width = `${percent}%`;

            if (percent >= 100) {
                stopTimer();
                activeProgress = null;
                root.replaceChildren();

                M.emit("YRM:ProgressResult", progress.id, {
                    completed: true
                });
            }
        }, 30);
    }


    Events.Subscribe("YRM:StartProgress", startProgress);
    Events.Subscribe("YRM:CloseUI", closeProgress);

    M.startProgress = startProgress;
    M.closeProgress = closeProgress;
    M.cancelProgress = cancelProgress;
})();

"use strict";

window.YRMModules = window.YRMModules || {};

YRMModules.element = function(tag, className, text) {
    const node = document.createElement(tag);

    if (className) node.className = className;
    if (text !== undefined) node.textContent = String(text);

    return node;
};

YRMModules.button = function(text, callback, primary = false) {
    const node = YRMModules.element(
        "button",
        primary ? "primary" : "",
        text
    );

    node.type = "button";
    node.addEventListener("click", callback);

    return node;
};

YRMModules.emit = function(type, id, data = {}) {
    Events.Call("YRM:UIAction", { type, id, data });
};

YRMModules.clearOverlay = function() {
    document.querySelector("#yrm-overlays").replaceChildren();
};

YRMModules.requestClose = function() {
    YRMModules.emit("YRM:CloseRequest", null, {});
};

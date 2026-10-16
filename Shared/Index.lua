
YRM = YRM or {}


YRM.Config = {
    Debug = true,
    UiName = "yrm-lib",
    NotificationDuration = 4000,
    ProgressDuration = 3000,
    MaxNotificationLength = 300,
}

YRM.Config.Commands = {
    Enabled = true,
    Prefix = "/",
}

YRM.Config.TestCommands = {
    Notify = "yrm-notify",
    Dialog = "yrm-dialog",
    Form = "yrm-form",
    Menu = "yrm-context-menu",
    ArrowMenu = "yrm-arrow-menu",
    ProgressBar = "yrm-progress-bar",
}

YRM.Events = {
    Notify = "YRM:ShowNotification",
    OpenDialog = "YRM:OpenDialog",
    OpenForm = "YRM:OpenForm",
    OpenContextMenu = "YRM:OpenContextMenu",
    Progress = "YRM:StartProgress",
    CloseUi = "YRM:CloseUI",
    UiReady = "YRM:UIReady",
    UiAction = "YRM:UIAction",
    RequestNotify = "YRM:RequestNotification",
}

function YRM.Log(message)
    if YRM.Config.Debug then
        Console.Log("[YRM] " .. tostring(message))
    end
end
